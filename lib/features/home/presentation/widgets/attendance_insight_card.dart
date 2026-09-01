import 'package:flutter/material.dart';
import '../../../../core/data/timetable_data.dart';
import '../../../../core/theme/app_colors.dart';

/// Shows how many more classes a student needs to attend to reach 75%,
/// or how many they can safely skip if already above 75%.
class AttendanceInsightCard extends StatelessWidget {
  final double present;
  final double total;

  const AttendanceInsightCard({
    super.key,
    required this.present,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();

    final percentage = present / total * 100;
    final isBelow = percentage < 75;

    String message;
    String highlightText;

    if (isBelow) {
      final n = AppTimetable.classesToReach(
        present: present,
        total: total,
      );
      if (n <= 0) {
        return const SizedBox.shrink();
      }
      message = 'Attend ';
      highlightText = '$n more class${n == 1 ? '' : 'es'}';
      message += '$highlightText to reach 75%.';
    } else {
      final n = AppTimetable.classesCanSkip(
        present: present,
        total: total,
      );
      if (n <= 0) {
        message = 'Great! You are right at the 75% threshold.';
        highlightText = '75%';
      } else {
        message = 'You can safely skip ';
        highlightText = '$n class${n == 1 ? '' : 'es'}';
        message += '$highlightText and stay above 75%.';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attendance Insight',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 4),

                _RichInsightText(
                  message: message,
                  highlightText: highlightText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RichInsightText extends StatelessWidget {
  final String message;
  final String highlightText;

  const _RichInsightText({
    required this.message,
    required this.highlightText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkText : AppColors.lightText;

    // Split message around the highlight
    final idx = message.indexOf(highlightText);
    if (idx < 0) {
      return Text(
        message,
        style: TextStyle(fontSize: 13, color: baseColor, height: 1.4),
      );
    }

    final before = message.substring(0, idx);
    final after  = message.substring(idx + highlightText.length);

    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 13, color: baseColor, height: 1.4),
        children: [
          if (before.isNotEmpty) TextSpan(text: before),
          TextSpan(
            text: highlightText,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (after.isNotEmpty) TextSpan(text: after),
        ],
      ),
    );
  }
}
