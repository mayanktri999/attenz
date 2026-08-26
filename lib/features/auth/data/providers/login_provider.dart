import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../auth_api.dart';
import '../auth_repository.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.watch(apiClientProvider);

  return AuthApi(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.watch(authApiProvider);

  return AuthRepository(api);
});