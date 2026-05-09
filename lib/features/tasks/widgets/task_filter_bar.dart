import 'package:flutter/material.dart';
import 'package:task_manager/core/theme/app_colors.dart';
import 'package:task_manager/features/tasks/providers/task_provider.dart';

/// Filter chip bar for All / Completed / Pending task filtering.
class TaskFilterBar extends StatelessWidget {
  final TaskFilter currentFilter;
  final ValueChanged<TaskFilter> onFilterChanged;
  final int allCount;
  final int completedCount;
  final int pendingCount;

  const TaskFilterBar({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.allCount,
    required this.completedCount,
    required this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FilterChip(
            label: 'All',
            count: allCount,
            isSelected: currentFilter == TaskFilter.all,
            onTap: () => onFilterChanged(TaskFilter.all),
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: 'Pending',
            count: pendingCount,
            isSelected: currentFilter == TaskFilter.pending,
            onTap: () => onFilterChanged(TaskFilter.pending),
            activeColor: AppColors.pendingOrange,
          ),
          const SizedBox(width: 10),
          _FilterChip(
            label: 'Completed',
            count: completedCount,
            isSelected: currentFilter == TaskFilter.completed,
            onTap: () => onFilterChanged(TaskFilter.completed),
            activeColor: AppColors.completedGreen,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.primaryLight;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? color
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isSelected
                      ? color
                      : Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
