import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/home_data_model.dart';
import '../presentation/viewmodels/home_viewmodel.dart';

final homeViewModelProvider =
    AsyncNotifierProvider<HomeViewModel, HomeDataModel>(
  HomeViewModel.new,
);