import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/auth/data/models/login_response.dart';
import '/features/auth/data/providers/auth_provider.dart';

final loginProvider =
    AsyncNotifierProvider<LoginNotifier, LoginResponse?>(
  LoginNotifier.new,
);

class LoginNotifier extends AsyncNotifier<LoginResponse?> {
  @override
  Future<LoginResponse?> build() async {
    return null;
  }

  Future<void> login({
    required String studentNumber,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return ref.read(authRepositoryProvider).login(
            studentNumber: studentNumber,
            password: password,
          );
    });
  }
}