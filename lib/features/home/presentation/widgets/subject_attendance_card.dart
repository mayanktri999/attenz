import 'package:flutter/material.dart';

import '../../../../core/utils/attendance_utils.dart';

class SubjectAttendanceCard extends StatelessWidget {
  final String subjectName;
  final double percentage;
  final VoidCallback? onTap;

  const SubjectAttendanceCard({
    super.key,
    required this.subjectName,
    required this.percentage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AttendanceUtils.getColor(percentage);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    subjectName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Text(
                  '${percentage.toInt()}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 7,
                backgroundColor: color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}