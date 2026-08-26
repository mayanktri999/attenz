
import 'models/login_response.dart';
import 'auth_api.dart';

class AuthRepository {
  final AuthApi api;

  AuthRepository(this.api);
Future<LoginResponse> login({
  required String studentNumber,
  required String password,
}) async {
  final response = await api.login(
    studentNumber: studentNumber,
    password: password,
  );

  return LoginResponse.fromJson(response);
}
}