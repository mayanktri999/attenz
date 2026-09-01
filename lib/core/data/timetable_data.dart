/// Hardcoded timetable for B.Tech CS, Section CS-2, Semester V, Session 2026-27.
/// Source: Physical timetable sheet, W.E.F. 21 July 2026.
///
/// This is used by the Timetable screen and Home screen (Today's Classes).
library;

class TSubject {
  final String code;
  final String name;
  final String faculty;
  final String room;

  const TSubject({
    required this.code,
    required this.name,
    required this.faculty,
    required this.room,
  });
}

class TSlot {
  final String startTime; // e.g. "8:30"
  final String endTime;   // e.g. "9:15"
  final TSubject? subject;
  final bool isBreak;
  final bool isLunch;
  final String? breakLabel;

  const TSlot({
    required this.startTime,
    required this.endTime,
    this.subject,
    this.isBreak = false,
    this.isLunch = false,
    this.breakLabel,
  });

  bool get isEmpty => subject == null && !isBreak && !isLunch;
}

class AppTimetable {
  AppTimetable._();

  // ── Subject Registry ─────────────────────────────────────────
  static const bcs501 = TSubject(
    code: 'BCS-501',
    name: 'Database Management System',
    faculty: 'Ms. Kriti Mishra',
    room: 'CL-20',
  );
  static const bcs502 = TSubject(
    code: 'BCS-502',
    name: 'Web Technology',
    faculty: 'Dr. Sonam Gupta',
    room: 'CL-20',
  );
  static const bcs503 = TSubject(
    code: 'BCS-503',
    name: 'Design & Analysis of Algorithm',
    faculty: 'Dr. Rajesh Prasad',
    room: 'CL-20',
  );
  static const bcs052 = TSubject(
    code: 'BCS-052',
    name: 'Data Analytics',
    faculty: 'Mrs. Kanika Malik',
    room: 'CL-20',
  );
  static const bcs055 = TSubject(
    code: 'BCS-055',
    name: 'Machine Learning',
    faculty: 'Ms. Sneha Mishra',
    room: 'CL-20',
  );
  static const bnc501 = TSubject(
    code: 'BNC-501',
    name: 'Constitution of India',
    faculty: 'Mr. Vishal Gupta',
    room: 'CL-20',
  );
  static const bcs551 = TSubject(
    code: 'BCS-551',
    name: 'DBMS Lab',
    faculty: 'Ms. Kriti Mishra',
    room: 'CC LAB / LAB 7',
  );
  static const bcs552 = TSubject(
    code: 'BCS-552',
    name: 'Web Technology Lab',
    faculty: 'Dr. Sonam Gupta',
    room: 'CC LAB / LAB 7',
  );
  static const bcs553 = TSubject(
    code: 'BCS-553',
    name: 'DAA Lab',
    faculty: 'Ms. Kanika Malik',
    room: 'CC LAB / LAB 7',
  );
  static const bcs554 = TSubject(
    code: 'BCS-554',
    name: 'Mini Project / Internship',
    faculty: 'Dr. Pradeep Gupta',
    room: 'CL-20',
  );

  // ── Break/Lunch helpers ──────────────────────────────────────
  static const _mentorship = TSlot(
    startTime: '10:00', endTime: '10:45',
    isBreak: true, breakLabel: 'Mentorship / Break',
  );
  static const _lunch = TSlot(
    startTime: '12:15', endTime: '1:00',
    isLunch: true, breakLabel: 'Lunch Break',
  );

  // ── Day schedules ────────────────────────────────────────────

  static const List<TSlot> monday = [
    TSlot(startTime: '8:30',  endTime: '9:15',  subject: bcs551),
    _mentorship,
    TSlot(startTime: '10:45', endTime: '11:30', subject: bcs055),
    TSlot(startTime: '11:30', endTime: '12:15', subject: bcs502),
    _lunch,
    TSlot(startTime: '1:00',  endTime: '1:45',  subject: bcs501),
    TSlot(startTime: '1:45',  endTime: '2:30',  subject: bcs503),
    TSlot(startTime: '2:30',  endTime: '3:15',  subject: bcs502),
    TSlot(startTime: '3:15',  endTime: '4:00',  subject: bcs052),
  ];

  static const List<TSlot> tuesday = [
    TSlot(startTime: '8:30',  endTime: '9:15',  subject: bnc501),
    TSlot(startTime: '9:15',  endTime: '10:00', subject: bcs052),
    _mentorship,
    TSlot(startTime: '10:45', endTime: '12:15', subject: bcs552),
    _lunch,
    TSlot(startTime: '1:00',  endTime: '1:45',  subject: bcs502),
    TSlot(startTime: '1:45',  endTime: '2:30',  subject: bcs503),
  ];

  static const List<TSlot> wednesday = [
    TSlot(startTime: '8:30',  endTime: '9:15',  subject: bcs501),
    TSlot(startTime: '9:15',  endTime: '10:00', subject: bcs503),
    _mentorship,
    TSlot(startTime: '10:45', endTime: '11:30', subject: bcs554),
    _lunch,
    TSlot(startTime: '1:00',  endTime: '2:30',  subject: bcs553),
    TSlot(startTime: '2:30',  endTime: '3:15',  subject: bcs502),
    TSlot(startTime: '3:15',  endTime: '4:00',  subject: bcs055),
  ];

  static const List<TSlot> thursday = [
    TSlot(startTime: '8:30',  endTime: '9:15',  subject: bcs052),
    TSlot(startTime: '9:15',  endTime: '10:00', subject: bcs501),
    _mentorship,
    TSlot(startTime: '10:45', endTime: '11:30', subject: bcs501),
    TSlot(startTime: '11:30', endTime: '12:15', subject: bcs503),
    _lunch,
    TSlot(startTime: '1:00',  endTime: '1:45',  subject: bcs055),
    TSlot(startTime: '1:45',  endTime: '2:30',  subject: bcs055),
  ];

  static const List<TSlot> friday = [
    TSlot(startTime: '8:30',  endTime: '9:15',  subject: bnc501),
    TSlot(startTime: '9:15',  endTime: '10:00', subject: bcs503),
    _mentorship,
    TSlot(startTime: '10:45', endTime: '11:30', subject: bcs052),
    TSlot(startTime: '11:30', endTime: '12:15', subject: bcs502),
    _lunch,
    TSlot(startTime: '1:00',  endTime: '1:45',  subject: bcs501),
  ];

  static const List<TSlot> saturday = [];

  /// Returns today's schedule.
  static List<TSlot> get todaySchedule {
    final day = DateTime.now().weekday; // 1=Mon … 7=Sun
    switch (day) {
      case DateTime.monday:    return monday;
      case DateTime.tuesday:   return tuesday;
      case DateTime.wednesday: return wednesday;
      case DateTime.thursday:  return thursday;
      case DateTime.friday:    return friday;
      default:                 return [];
    }
  }

  /// Returns schedule for a given weekday index (0=Mon … 5=Sat).
  static List<TSlot> scheduleForIndex(int index) {
    switch (index) {
      case 0: return monday;
      case 1: return tuesday;
      case 2: return wednesday;
      case 3: return thursday;
      case 4: return friday;
      default: return [];
    }
  }

  /// All unique theory/lab subjects (for attendance breakdown).
  static const List<TSubject> allSubjects = [
    bcs501, bcs502, bcs503, bcs052, bcs055,
    bnc501, bcs551, bcs552, bcs553, bcs554,
  ];

  /// Parse "H:MM" string to minutes since midnight.
  static int parseMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  /// Returns the currently active slot in [todaySchedule], or null.
  static TSlot? get currentSlot {
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    for (final slot in todaySchedule) {
      final start = parseMinutes(slot.startTime);
      final end   = parseMinutes(slot.endTime);
      if (nowMinutes >= start && nowMinutes < end) return slot;
    }
    return null;
  }

  /// Calculates classes needed to reach [targetPercent] (default 75).
  static int classesToReach({
    required double present,
    required double total,
    double targetPercent = 75,
  }) {
    final target = targetPercent / 100;
    if (present / total >= target) return 0;
    // (present + n) / (total + n) >= target
    // present + n >= target*(total + n)
    // n(1 - target) >= target*total - present
    final n = (target * total - present) / (1 - target);
    return n.ceil();
  }

  /// Calculates how many classes can be skipped while staying above [targetPercent].
  static int classesCanSkip({
    required double present,
    required double total,
    double targetPercent = 75,
  }) {
    final target = targetPercent / 100;
    if (present / total < target) return 0;
    // present / (total + n) >= target
    // n <= present/target - total
    final n = present / target - total;
    return n.floor().clamp(0, 9999);
  }
}
