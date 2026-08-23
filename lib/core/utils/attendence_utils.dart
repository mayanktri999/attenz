import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AttendanceStatus {
  healthy,
  warning,
  critical,
}

class AttendanceUtils {
  AttendanceUtils._();

  static AttendanceStatus getStatus(double percentage) {
    if (percentage > 75) {
      return AttendanceStatus.healthy;
    }

    if (percentage >= 60) {
      return AttendanceStatus.warning;
    }

    return AttendanceStatus.critical;
  }

  static Color getColor(double percentage) {
    switch (getStatus(percentage)) {
      case AttendanceStatus.healthy:
        return AppColors.attendanceGreen;

      case AttendanceStatus.warning:
        return AppColors.attendanceYellow;

      case AttendanceStatus.critical:
        return AppColors.attendanceRed;
    }
  }

  static String getLabel(double percentage) {
    switch (getStatus(percentage)) {
      case AttendanceStatus.healthy:
        return 'Healthy';

      case AttendanceStatus.warning:
        return 'Needs Attention';

      case AttendanceStatus.critical:
        return 'Critical';
    }
  }
}