class HomeDataModel {
  final double overallAttendance;
  final List<SubjectAttendanceModel> subjects;
  final List<TodayClassModel> todayClasses;

  const HomeDataModel({
    required this.overallAttendance,
    required this.subjects,
    required this.todayClasses,
  });
}

class SubjectAttendanceModel {
  final String id;
  final String name;
  final double attendance;

  const SubjectAttendanceModel({
    required this.id,
    required this.name,
    required this.attendance,
  });
}

class TodayClassModel {
  final String subject;
  final String time;
  final String room;

  const TodayClassModel({
    required this.subject,
    required this.time,
    required this.room,
  });
}