import 'package:dio/dio.dart';

import '/core/network/network_exception.dart';
import 'attendance_api.dart';
import 'models/attendance_model.dart';

/// Converts raw API responses into [AttendanceModel].
///
/// Translates [DioException] into user-friendly [NetworkException]
/// messages. No UI code belongs here.
class AttendanceRepository {
  final AttendanceApi _api;

  AttendanceRepository(this._api);

  /// Fetches attendance for the given [studentNumber].
  ///
  /// Throws [NetworkException] with a user-friendly message on failure.
  Future<AttendanceModel> getAttendance(String studentNumber) async {
    try {
      final data =
          await _api.getAttendanceByStudentNumber(studentNumber);

      return AttendanceModel.fromJson(data);
    } on DioException catch (e) {
      throw NetworkException(
        message: _mapDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Server took too long to respond. Please try again.';

      case DioExceptionType.connectionError:
        return 'Unable to connect. Please check your internet connection.';

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return 'Student data was not found. Please check your student number.';
        }
        if (statusCode == 500) {
          return 'Server error. Please try again later.';
        }
        return 'Request failed (HTTP $statusCode).';

      case DioExceptionType.unknown:
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
