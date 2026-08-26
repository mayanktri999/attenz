import 'package:dio/dio.dart';

import 'models/login_request.dart';
import 'models/login_response.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<LoginResponse> login(
    LoginRequest request,
  ) async {
    final response = await dio.post(
      '/auth/login',
      data: request.toJson(),
    );

    return LoginResponse.fromJson(
      response.data,
    );
  }
}