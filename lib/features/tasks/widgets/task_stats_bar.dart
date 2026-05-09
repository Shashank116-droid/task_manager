import 'package:flutter/material.dart';
import 'package:task_manager/core/theme/app_colors.dart';

/// Stats overview showing total, completed, and pending task counts.
class TaskStatsBar extends StatelessWidget {
  final int total;
  final int completed;
  final int pending;

  const TaskStatsBar({
    super.key,
    required this.total,
    required this.completed,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _StatItem(
            icon: Icons.list_alt_rounded,
            label: 'Total',
            count: total,
            color: AppColors.primaryLight,
          ),
          const SizedBox(width: 12),
          _StatItem(
            icon: Icons.check_circle_outline_rounded,
            label: 'Done',
            count: completed,
            color: AppColors.completedGreen,
          ),
          const SizedBox(width: 12),
          _StatItem(
            icon: Icons.pending_outlined,
            label: 'Pending',
            count: pending,
            color: AppColors.pendingOrange,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
