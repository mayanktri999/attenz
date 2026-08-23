import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/attendance_utils.dart';

class OverallAttendanceCard extends StatelessWidget {
  final double percentage;

  const OverallAttendanceCard({
    super.key,
    required this.percentage,
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
            style: AppTypography.percentage.copyWith(
              color: color,
            ),
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
        ],
      ),
    );
  }
}