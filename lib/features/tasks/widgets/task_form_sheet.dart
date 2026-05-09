import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/constants/app_strings.dart';
import 'package:task_manager/core/theme/app_colors.dart';
import 'package:task_manager/core/utils/date_helper.dart';
import 'package:task_manager/core/utils/validators.dart';
import 'package:task_manager/core/widgets/custom_text_field.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/features/auth/providers/auth_provider.dart';
import 'package:task_manager/features/tasks/models/task_model.dart';
import 'package:task_manager/features/tasks/providers/task_provider.dart';
import 'package:task_manager/core/utils/snackbar_helper.dart';

/// Bottom sheet form for adding or editing a task.
class TaskFormSheet extends StatefulWidget {
  final TaskModel? task; // null = adding, non-null = editing

  const TaskFormSheet({super.key, this.task});

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _selectedDate;
  bool _isSubmitting = false;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _selectedDate = widget.task?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primaryLight),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final userId = context.read<AuthProvider>().user!.uid;
    final taskProvider = context.read<TaskProvider>();

    bool success;
    if (isEditing) {
      final updatedTask = widget.task!.copyWith(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
      );
      success = await taskProvider.updateTask(
        userId: userId,
        task: updatedTask,
      );
    } else {
      success = await taskProvider.addTask(
        userId: userId,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
      );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.pop(context);
      SnackBarHelper.showSuccess(
        context,
        isEditing ? AppStrings.taskUpdated : AppStrings.taskAdded,
      );
    } else {
      SnackBarHelper.showError(context, 'Failed to save task. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Drag Handle ────────────────────────
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // ── Title ──────────────────────────────
                Text(
                  isEditing ? AppStrings.editTask : AppStrings.addTask,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),

                // ── Task Title Field ───────────────────
                CustomTextField(
                  controller: _titleController,
                  hintText: AppStrings.taskTitle,
                  prefixIcon: Icons.title_rounded,
                  validator: Validators.taskTitle,
                  maxLength: 100,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // ── Description Field ──────────────────
                CustomTextField(
                  controller: _descriptionController,
                  hintText: AppStrings.taskDescription,
                  prefixIcon: Icons.notes_rounded,
                  validator: Validators.taskDescription,
                  maxLines: 3,
                  maxLength: 500,
                  keyboardType: TextInputType.multiline, // <--- Fixed here
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 16),

                // ── Date Picker ────────────────────────
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: AppStrings.taskDate,
                      prefixIcon: Icon(
                        Icons.calendar_today_rounded,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      DateHelper.formatDate(_selectedDate),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Submit Button ──────────────────────
                PrimaryButton(
                  text: isEditing ? AppStrings.save : AppStrings.addTask,
                  isLoading: _isSubmitting,
                  onPressed: _handleSubmit,
                  icon: isEditing ? Icons.save_rounded : Icons.add_rounded,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
