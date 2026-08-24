class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';

  // Student
  static const String profile = '/student/profile';
  static const String home = '/student/home';
  static const String attendance = '/student/attendance';
  static const String timetable = '/student/timetable';

  // Chat
  static const String chatGroups = '/chat/groups';
}