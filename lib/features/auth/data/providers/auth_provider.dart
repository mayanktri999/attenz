import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/network/api_client.dart';
import '/features/auth/data/auth_api.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.watch(apiClientProvider);

  return AuthApi(dio);
});