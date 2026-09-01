import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/data/timetable_data.dart';
import '/core/network/network_exception.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/attendance_utils.dart';
import '/features/attendance/data/providers/attendance_providers.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceProvider);

    return Scaffold(
      body: SafeArea(
        child: attendanceAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),

          error: (error, _) {
            final msg = error is NetworkException
                ? error.message
                : 'Something went wrong.';
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 48),
                  const SizedBox(height: 16),
                  Text(msg, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => ref.invalidate(attendanceProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          },

          data: (attendance) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final present = attendance.overallPresent;
            final total   = attendance.overallLecture;
            final pct     = attendance.overallPercentage;

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async =>
                  ref.invalidate(attendanceProvider),

              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [

                  // ── App Bar ─────────────────────────────────
                  SliverAppBar(
                    floating: true,
                    backgroundColor: isDark
                        ? AppColors.darkBackground
                        : AppColors.background,
                    title: const Text(
                      'Attendance',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    centerTitle: false,
                    elevation: 0,
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([

                        // ── Overall Summary Card ─────────────────
                        _OverallCard(
                          percentage: pct,
                          present: present.toInt(),
                          total: total.toInt(),
                          isDark: isDark,
                        ),

                        const SizedBox(height: 20),

                        // ── Section heading ──────────────────────
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Subject-wise Overview',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Sem V · CS-2',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Overall attendance applied across enrolled subjects',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkSecondaryText
                                : AppColors.lightSecondaryText,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ── Subject tiles ────────────────────────
                        ...AppTimetable.allSubjects.map((subject) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _SubjectTile(
                              subject: subject,
                              percentage: pct,
                              isDark: isDark,
                            ),
                          );
                        }),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Overall summary card ─────────────────────────────────────────────────────

class _OverallCard extends StatelessWidget {
  final double percentage;
  final int present;
  final int total;
  final bool isDark;

  const _OverallCard({
    required this.percentage,
    required this.present,
    required this.total,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = AttendanceUtils.getColor(percentage);
    final label = AttendanceUtils.getLabel(percentage);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.85),
            color,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Attendance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${percentage.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _WhiteStat(label: 'Present', value: '$present'),
              const SizedBox(height: 10),
              _WhiteStat(label: 'Total', value: '$total'),
              const SizedBox(height: 10),
              _WhiteStat(label: 'Absent', value: '${total - present}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _WhiteStat extends StatelessWidget {
  final String label;
  final String value;

  const _WhiteStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800)),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

// ── Subject tile ─────────────────────────────────────────────────────────────

class _SubjectTile extends StatelessWidget {
  final TSubject subject;
  final double percentage;
  final bool isDark;

  const _SubjectTile({
    required this.subject,
    required this.percentage,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = AttendanceUtils.getColor(percentage);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Code chip
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  subject.code,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),

              const Spacer(),

              Text(
                '${percentage.toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            subject.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            '${subject.faculty}  ·  ${subject.room}',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkSecondaryText
                  : AppColors.lightSecondaryText,
            ),
          ),

          const SizedBox(height: 10),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}