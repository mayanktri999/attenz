import 'package:dio/dio.dart';

import 'api_endpoints.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get(
      path,
      queryParameters: queryParameters,
    );
  }

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
  }) {
    return dio.post(
      path,
      data: data,
    );
  }

  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
  }) {
    return dio.put(
      path,
      data: data,
    );
  }

  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
  }) {
    return dio.delete(
      path,
      data: data,
    );
  }
}