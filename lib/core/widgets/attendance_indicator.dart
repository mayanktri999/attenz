import 'package:flutter/material.dart';
import '../utils/attendance_utils.dart';

class AttendanceIndicator extends StatelessWidget {
  final double percentage;

  const AttendanceIndicator({
    super.key,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final color = AttendanceUtils.getColor(percentage);
    final label = AttendanceUtils.getLabel(percentage);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}