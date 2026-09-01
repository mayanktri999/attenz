import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/attendance_utils.dart';

class OverallAttendanceCard extends StatelessWidget {
  final double percentage;
  final int presentClasses;
  final int totalClasses;

  const OverallAttendanceCard({
    super.key,
    required this.percentage,
    required this.presentClasses,
    required this.totalClasses,
  });

  @override
  Widget build(BuildContext context) {
    final color = AttendanceUtils.getColor(percentage);
    final label = AttendanceUtils.getLabel(percentage);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            'Overall Attendance',
            style: AppTypography.subtitle,
          ),

          const SizedBox(height: 20),

          Text(
            '${percentage.toInt()}%',
            style: AppTypography.percentage.copyWith(color: color),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Divider(height: 1),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                label: 'Present',
                value: '$presentClasses',
                color: AppColors.attendanceGreen,
              ),
              _StatItem(
                label: 'Total',
                value: '$totalClasses',
                color: Theme.of(context).colorScheme.onSurface,
              ),
              _StatItem(
                label: 'Missed',
                value: '${totalClasses - presentClasses}',
                color: AppColors.attendanceRed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}