import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/home_data_model.dart';
import '../../data/repositories/home_repository.dart';

class HomeViewModel
    extends AsyncNotifier<HomeDataModel> {

  late final HomeRepository _repository;

  @override
  Future<HomeDataModel> build() async {
    _repository = HomeRepository();

    return _repository.getHomeData();
  }

  Future<void> refreshHome() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _repository.getHomeData(),
    );
  }
}