class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl =
      'https://erp-backend-1-gpyb.onrender.com/api';

  // =========================
  // Version
  // =========================

  static const String versionCheck = '/version/check';

  static const String adminVersion = '/admin/version';

  static String forceUpdate(String platform) =>
      '/admin/version/force-update/$platform';

  static String blockPlatform(String platform) =>
      '/admin/version/block/$platform';

  // =========================
  // Admin Authentication
  // =========================

  static const String adminLogin = '/admin/auth/login';

  static const String adminProfile = '/admin/auth/profile';

  // =========================
  // Users (protected)
  // =========================

  static const String users = '/users';

  static String userById(String id) => '/users/$id';

  static String userByRollNumber(String rollNumber) =>
      '/users/roll/$rollNumber';

  static String userByAdmissionNumber(String admissionNumber) =>
      '/users/admission/$admissionNumber';

  static String userByStudentNumber(String studentNumber) =>
      '/users/student/$studentNumber';

  static const String userSearch = '/users/search';

  // =========================
  // Attendance
  // =========================

  static const String attendance = '/attendance';

  static String attendanceById(String id) => '/attendance/$id';

  static String attendanceByUserId(String userId) =>
      '/attendance/user/$userId';

  static String attendanceByStudentNumber(String studentNumber) =>
      '/attendance/student/$studentNumber';

  static const String lowAttendance = '/attendance/low';

  /// Public endpoint — no auth required.
  /// Primary data source for the student mobile app.
  static String attendanceSearch(String studentNumber) =>
      '/attendance/search/$studentNumber';

  static const String upsertUserAttendance = '/upsert-user-attendance';

  // =========================
  // Timetable (protected)
  // =========================

  static const String timetable = '/timetable';

  static String timetableById(String id) => '/timetable/$id';

  static String timetableBySection(String section) =>
      '/timetable/section/$section';

  static const String timetableQuery = '/timetable/query';

  static String timetableWithSlots(String id) =>
      '/timetable/$id/with-slots';

  // =========================
  // Time Slots (protected)
  // =========================

  static const String timeSlots = '/timeslot';

  static const String initializeTimeSlots = '/timeslot/initialize';
}