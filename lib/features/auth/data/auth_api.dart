import 'package:dio/dio.dart';

import '/core/network/api_endpoints.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<Map<String, dynamic>> login({
    required String studentNumber,
    required String password,
  }) async {
    final response = await dio.post(
      ApiEndpoints.login,
      data: {
        'student_number': studentNumber,
        'password': password,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }
}