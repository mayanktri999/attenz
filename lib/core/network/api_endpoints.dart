class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://erp-backend-1-gpyb.onrender.com/api';

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