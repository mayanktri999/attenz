import 'models/login_request.dart';
import 'models/login_response.dart';
import 'auth_api.dart';

class AuthRepository {
  final AuthApi api;

  AuthRepository(this.api);

  Future<LoginResponse> login({
    required String studentNumber,
    required String password,
  }) {
    return api.login(
      LoginRequest(
        studentNumber: studentNumber,
        password: password,
      ),
    );
  }
}