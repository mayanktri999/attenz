import 'package:dio/dio.dart';

import '/core/network/api_endpoints.dart';

/// Thin Dio wrapper for the attendance API.
///
/// Only exposes endpoints that are usable by the student app.
/// Throws [DioException] on failure — the repository layer
/// translates these into user-friendly errors.
class AttendanceApi {
  final Dio _dio;

  AttendanceApi(this._dio);

  /// Calls `GET /attendance/search/:studentNumber`.
  ///
  /// This is the primary public endpoint for the student app.
  /// No authentication token is required.
  Future<Map<String, dynamic>> getAttendanceByStudentNumber(
    String studentNumber,
  ) async {
    final response = await _dio.get(
      ApiEndpoints.attendanceSearch(studentNumber),
    );

    return Map<String, dynamic>.from(response.data as Map);
  }
}
