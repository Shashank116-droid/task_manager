import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/quote_provider.dart';
import '../models/task_model.dart';
import '../constants/app_strings.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form_sheet.dart';
import '../widgets/task_filter_bar.dart';
import '../widgets/quote_card.dart';
import '../widgets/task_stats_bar.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/empty_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<TaskProvider>().fetchTasks(user.uid);
        context.read<QuoteProvider>().refresh();
      }
    });
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, builder: (_) => const TaskFormSheet());
  }

  void _showEditTaskSheet(TaskModel task) {
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, builder: (_) => TaskFormSheet(task: task));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final themeProvider = context.read<ThemeProvider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<TaskProvider>().fetchTasks(authProvider.user!.uid);
          await context.read<QuoteProvider>().refresh();
        },
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, _) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  floating: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(AppStrings.tasksTitle, style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color, fontWeight: FontWeight.bold)),
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                      onPressed: () => themeProvider.toggleTheme(!themeProvider.isDarkMode),
                    ),
                    IconButton(icon: const Icon(Icons.logout_rounded), onPressed: () => authProvider.logout()),
                    const SizedBox(width: 8),
                  ],
                ),
                const SliverToBoxAdapter(child: QuoteCard()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TaskStatsBar(total: taskProvider.totalCount, completed: taskProvider.completedCount, pending: taskProvider.pendingCount),
                  ).animate().fadeIn(delay: 200.ms),
                ),
                const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.symmetric(vertical: 16), child: TaskFilterBar())),
                if (taskProvider.isLoading)
                  const SliverFillRemaining(child: ShimmerLoading())
                else if (taskProvider.error != null)
                  SliverFillRemaining(child: Center(child: Text(taskProvider.error!)))
                else if (taskProvider.filteredTasks.isEmpty)
                  const SliverFillRemaining(child: EmptyState(icon: Icons.assignment_turned_in_rounded, title: 'No tasks found', subtitle: 'Time to add some new goals!'))
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = taskProvider.filteredTasks[index];
                          return TaskCard(
                            task: task,
                            onToggle: () => taskProvider.toggleTaskStatus(userId: authProvider.user!.uid, task: task),
                            onEdit: () => _showEditTaskSheet(task),
                            onDelete: () => taskProvider.deleteTask(userId: authProvider.user!.uid, taskId: task.id),
                          ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1);
                        },
                        childCount: taskProvider.filteredTasks.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskSheet,
        label: const Text('New Task'),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ).animate().scale(delay: 400.ms),
    );
  }
}
