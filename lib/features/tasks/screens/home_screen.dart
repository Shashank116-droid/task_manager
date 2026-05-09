import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_manager/core/constants/app_strings.dart';
import 'package:task_manager/core/widgets/empty_state.dart';
import 'package:task_manager/core/widgets/shimmer_loading.dart';
import 'package:task_manager/core/utils/snackbar_helper.dart';
import 'package:task_manager/features/auth/providers/auth_provider.dart';
import 'package:task_manager/features/auth/screens/login_screen.dart';
import 'package:task_manager/features/quotes/providers/quote_provider.dart';
import 'package:task_manager/features/tasks/models/task_model.dart';
import 'package:task_manager/features/tasks/providers/task_provider.dart';
import 'package:task_manager/features/tasks/widgets/quote_card.dart';
import 'package:task_manager/features/tasks/widgets/task_card.dart';
import 'package:task_manager/features/tasks/widgets/task_filter_bar.dart';
import 'package:task_manager/features/tasks/widgets/task_form_sheet.dart';
import 'package:task_manager/features/tasks/widgets/task_stats_bar.dart';
import 'package:task_manager/core/theme/theme_provider.dart';

/// Main home screen displaying tasks, quotes, and stats.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize data after the first frame to ensure providers are ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.uid;
      if (userId != null) {
        context.read<TaskProvider>().initTasks(userId);
        context.read<QuoteProvider>().fetchQuote();
      }
    });
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const TaskFormSheet(),
    );
  }

  void _showEditTaskSheet(TaskModel task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => TaskFormSheet(task: task),
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(AppStrings.logout),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              AppStrings.logout,
              style: TextStyle(color: Colors.red.shade600),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<TaskProvider>().clear();
      await context.read<AuthProvider>().signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.user?.displayName ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName 👋',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              AppStrings.myTasks,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        toolbarHeight: 70,
        actions: [
          // Theme toggle
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  size: 22,
                ),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: AppStrings.darkMode,
              );
            },
          ),
          // Logout
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 22),
            onPressed: _handleLogout,
            tooltip: AppStrings.logout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        child: const Icon(Icons.add_rounded, size: 28),
      ).animate().scale(delay: 300.ms, duration: 400.ms),
      body: RefreshIndicator(
        onRefresh: () async {
          final userId = context.read<AuthProvider>().user?.uid;
          if (userId != null) {
            context.read<TaskProvider>().initTasks(userId);
            await context.read<QuoteProvider>().refresh();
          }
        },
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, _) {
            return CustomScrollView(
              slivers: [
                // ── Quote Card ─────────────────────────
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: QuoteCard(),
                  ),
                ),

                // ── Stats Bar ──────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TaskStatsBar(
                      total: taskProvider.totalCount,
                      completed: taskProvider.completedCount,
                      pending: taskProvider.pendingCount,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                ),

                // ── Filter Bar ─────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 8),
                    child: TaskFilterBar(
                      currentFilter: taskProvider.currentFilter,
                      onFilterChanged: (filter) =>
                          taskProvider.setFilter(filter),
                      allCount: taskProvider.totalCount,
                      completedCount: taskProvider.completedCount,
                      pendingCount: taskProvider.pendingCount,
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
                ),

                // ── Task List ──────────────────────────
                if (taskProvider.isLoading)
                  const SliverFillRemaining(child: ShimmerLoading())
                else if (taskProvider.error != null)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(taskProvider.error!),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              final userId = context
                                  .read<AuthProvider>()
                                  .user
                                  ?.uid;
                              if (userId != null) {
                                taskProvider.initTasks(userId);
                              }
                            },
                            child: const Text(AppStrings.retry),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (taskProvider.filteredTasks.isEmpty)
                  SliverFillRemaining(
                    child: EmptyState(
                      icon: _emptyIcon(taskProvider.currentFilter),
                      title: _emptyTitle(taskProvider.currentFilter),
                      subtitle: _emptySubtitle(taskProvider.currentFilter),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final task = taskProvider.filteredTasks[index];
                        return TaskCard(
                          key: ValueKey(task.id),
                          task: task,
                          onToggle: () => _toggleTask(task),
                          onEdit: () => _showEditTaskSheet(task),
                          onDelete: () => _deleteTask(task),
                        ).animate().fadeIn(
                          delay: Duration(milliseconds: 50 * index),
                          duration: 300.ms,
                        );
                      }, childCount: taskProvider.filteredTasks.length),
                    ),
                  ),

                // Bottom padding for FAB
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
    );
  }

  void _toggleTask(TaskModel task) {
    final userId = context.read<AuthProvider>().user!.uid;
    context
        .read<TaskProvider>()
        .toggleTaskStatus(userId: userId, task: task)
        .then((success) {
          if (success && mounted) {
            SnackBarHelper.showSuccess(
              context,
              task.isCompleted
                  ? AppStrings.taskPending
                  : AppStrings.taskCompleted,
            );
          }
        });
  }

  void _deleteTask(TaskModel task) {
    final userId = context.read<AuthProvider>().user!.uid;
    context
        .read<TaskProvider>()
        .deleteTask(userId: userId, taskId: task.id)
        .then((success) {
          if (success && mounted) {
            SnackBarHelper.showSuccess(context, AppStrings.taskDeleted);
          }
        });
  }

  IconData _emptyIcon(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.completed:
        return Icons.check_circle_outline_rounded;
      case TaskFilter.pending:
        return Icons.pending_outlined;
      case TaskFilter.all:
        return Icons.inbox_rounded;
    }
  }

  String _emptyTitle(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.completed:
        return AppStrings.noCompletedTasks;
      case TaskFilter.pending:
        return AppStrings.noPendingTasks;
      case TaskFilter.all:
        return AppStrings.noTasks;
    }
  }

  String _emptySubtitle(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.completed:
        return 'Complete a task and it will show up here';
      case TaskFilter.pending:
        return 'All tasks are completed! Great job! 🎉';
      case TaskFilter.all:
        return AppStrings.noTasksSubtitle;
    }
  }
}
