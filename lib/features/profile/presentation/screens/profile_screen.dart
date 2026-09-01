import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/app_colors.dart';
import '/features/attendance/data/providers/attendance_providers.dart';
import '/features/student/providers/current_student_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: attendanceAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, err) => _ProfileShell(
            isDark: isDark,
            initials: '?',
            name: 'Student',
            items: const [],
            onSignOut: () => _signOut(context, ref),
          ),
          data: (attendance) {
            final user = attendance.user;
            final name = user?.fullName.isNotEmpty == true
                ? user!.fullName
                : 'Student';

            // Initials
            final parts = name.trim().split(' ');
            final initials = parts.length >= 2
                ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
                : name.substring(0, name.length.clamp(1, 2)).toUpperCase();

            final items = <_ProfileItem>[
              if (user?.rollNumber.isNotEmpty == true)
                _ProfileItem(
                  icon: Icons.badge_outlined,
                  label: 'Roll Number',
                  value: user!.rollNumber,
                ),
              if (user?.admissionNumber.isNotEmpty == true)
                _ProfileItem(
                  icon: Icons.numbers_outlined,
                  label: 'Admission Number',
                  value: user!.admissionNumber,
                ),
              if (user?.email?.isNotEmpty == true)
                _ProfileItem(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: user!.email!,
                ),
              if (user?.mobileNumber?.isNotEmpty == true)
                _ProfileItem(
                  icon: Icons.phone_outlined,
                  label: 'Mobile',
                  value: user!.mobileNumber!,
                ),
              if (user?.gender?.isNotEmpty == true)
                _ProfileItem(
                  icon: Icons.person_outline,
                  label: 'Gender',
                  value: _capitalize(user!.gender!),
                ),
              if (user?.age != null)
                _ProfileItem(
                  icon: Icons.cake_outlined,
                  label: 'Age',
                  value: '${user!.age} years',
                ),
              _ProfileItem(
                icon: Icons.school_outlined,
                label: 'Section',
                value: 'CS-2 · B.Tech CS · Sem V',
              ),
              _ProfileItem(
                icon: Icons.percent_outlined,
                label: 'Attendance',
                value:
                    '${attendance.overallPercentage.toInt()}%  (${attendance.overallPresent.toInt()}/${attendance.overallLecture.toInt()})',
              ),
            ];

            return _ProfileShell(
              isDark: isDark,
              initials: initials,
              name: name,
              items: items,
              onSignOut: () => _signOut(context, ref),
            );
          },
        ),
      ),
    );
  }

  static void _signOut(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text(
            'Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Sign out',
              style: TextStyle(color: AppColors.attendanceRed),
            ),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        ref.read(currentStudentNumberProvider.notifier).clear();
        context.go('/login');
      }
    });
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

// ── Shell ─────────────────────────────────────────────────────────────────────

class _ProfileShell extends StatelessWidget {
  final bool isDark;
  final String initials;
  final String name;
  final List<_ProfileItem> items;
  final VoidCallback onSignOut;

  const _ProfileShell({
    required this.isDark,
    required this.initials,
    required this.name,
    required this.items,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Header ──────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFFFF8C3A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.6),
                        width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'B.Tech CS · Section CS-2 · Sem V',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Info cards ────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    _InfoRow(item: items[i], isDark: isDark),
                    if (i < items.length - 1)
                      Divider(
                        height: 1,
                        indent: 56,
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // ── Sign out ──────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          sliver: SliverToBoxAdapter(
            child: TextButton.icon(
              onPressed: onSignOut,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: AppColors.attendanceRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                      color: AppColors.attendanceRed.withValues(alpha: 0.3)),
                ),
              ),
              icon: const Icon(Icons.logout_outlined),
              label: const Text(
                'Sign out',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final _ProfileItem item;
  final bool isDark;

  const _InfoRow({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}