import 'package:flutter/material.dart';

import '/core/data/timetable_data.dart';
import '/core/theme/app_colors.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  // Default to today's weekday (0-indexed, Mon=0)
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    final wd = DateTime.now().weekday; // 1=Mon…7=Sun
    _selectedDay = (wd - 1).clamp(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final slots  = AppTimetable.scheduleForIndex(_selectedDay);

    // Non-empty slots (has a subject, break, or lunch)
    final visible = slots.where((s) => !s.isEmpty).toList();

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Timetable',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Weekly schedule · B.Tech CS · Sem V',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Day tabs ─────────────────────────────────────────
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _days.length,
                itemBuilder: (context, i) {
                  final isSelected = i == _selectedDay;
                  final isToday =
                      i == (DateTime.now().weekday - 1).clamp(0, 5);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface),
                        borderRadius: BorderRadius.circular(22),
                        border: isToday && !isSelected
                            ? Border.all(color: AppColors.primary, width: 1.5)
                            : null,
                      ),
                      child: Text(
                        _days[i],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // ── Slot list ─────────────────────────────────────────
            Expanded(
              child: visible.isEmpty
                  ? _EmptyDay(isDark: isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      itemCount: visible.length,
                      itemBuilder: (context, i) {
                        final slot = visible[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _SlotCard(
                            slot: slot,
                            isDark: isDark,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Slot card ─────────────────────────────────────────────────────────────────

class _SlotCard extends StatelessWidget {
  final TSlot slot;
  final bool isDark;

  const _SlotCard({required this.slot, required this.isDark});

  bool get _isNow {
    final now = DateTime.now();
    final nowMin = now.hour * 60 + now.minute;
    final start  = AppTimetable.parseMinutes(slot.startTime);
    final end    = AppTimetable.parseMinutes(slot.endTime);
    return nowMin >= start && nowMin < end;
  }

  @override
  Widget build(BuildContext context) {
    if (slot.isBreak || slot.isLunch) return _BreakCard(slot: slot, isDark: isDark);

    final subject = slot.subject!;
    final isNow   = _isNow;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNow
            ? AppColors.primary.withValues(alpha: 0.06)
            : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
        borderRadius: BorderRadius.circular(16),
        border: isNow
            ? Border.all(color: AppColors.primary, width: 1.8)
            : Border.all(
                color:
                    isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: isNow
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time column
          SizedBox(
            width: 62,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.startTime,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isNow ? AppColors.primary : null,
                  ),
                ),
                const SizedBox(height: 2),
                if (isNow)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                else
                  Text(
                    slot.endTime,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Subject info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${subject.room}  ·  ${slot.startTime}–${slot.endTime}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subject.faculty,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
              ],
            ),
          ),

          // Subject code chip
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              subject.code,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakCard extends StatelessWidget {
  final TSlot slot;
  final bool isDark;

  const _BreakCard({required this.slot, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final icon = slot.isLunch ? Icons.restaurant_outlined : Icons.coffee_outlined;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.5)
            : AppColors.lightBorder.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 62,
            child: Text(
              slot.startTime,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
              ),
            ),
          ),
          Icon(
            icon,
            size: 16,
            color: isDark
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
          ),
          const SizedBox(width: 8),
          Text(
            slot.breakLabel ?? (slot.isLunch ? 'Lunch Break' : 'Break'),
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkSecondaryText
                  : AppColors.lightSecondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  final bool isDark;

  const _EmptyDay({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.weekend_outlined,
            size: 56,
            color: isDark
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
          ),
          const SizedBox(height: 16),
          Text(
            'No classes scheduled',
            style: TextStyle(
              fontSize: 16,
              color: isDark
                  ? AppColors.darkSecondaryText
                  : AppColors.lightSecondaryText,
            ),
          ),
        ],
      ),
    );
  }
}