import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/network/api_client.dart';
import '/features/student/providers/current_student_provider.dart';
import '../attendance_api.dart';
import '../attendance_repository.dart';
import '../models/attendance_model.dart';

/// Provides a scoped [AttendanceApi] wired to the shared Dio instance.
final attendanceApiProvider = Provider<AttendanceApi>((ref) {
  final dio = ref.watch(apiClientProvider);
  return AttendanceApi(dio);
});

/// Provides a scoped [AttendanceRepository].
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final api = ref.watch(attendanceApiProvider);
  return AttendanceRepository(api);
});

/// Fetches real attendance data for the current student.
///
/// Automatically re-fetches when [currentStudentNumberProvider] changes.
/// Throws if the student number is not set.
final attendanceProvider = FutureProvider<AttendanceModel>((ref) async {
  final studentNumber = ref.watch(currentStudentNumberProvider);

  if (studentNumber == null || studentNumber.isEmpty) {
    throw Exception('No student number available. Please log in.');
  }

  final repository = ref.watch(attendanceRepositoryProvider);
  return repository.getAttendance(studentNumber);
});
