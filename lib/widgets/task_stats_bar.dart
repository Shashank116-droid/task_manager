import 'package:flutter/material.dart';

class TaskStatsBar extends StatelessWidget {
  final int total;
  final int completed;
  final int pending;

  const TaskStatsBar({super.key, required this.total, required this.completed, required this.pending});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _StatItem(label: 'All', count: total, color: Colors.blue),
          const SizedBox(width: 12),
          _StatItem(label: 'Done', count: completed, color: Colors.green),
          const SizedBox(width: 12),
          _StatItem(label: 'Todo', count: pending, color: Colors.orange),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatItem({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(count.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.8), fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
