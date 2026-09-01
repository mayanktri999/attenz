import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/attendance/data/models/attendance_model.dart';
import '../presentation/viewmodels/home_viewmodel.dart';

final homeViewModelProvider =
    AsyncNotifierProvider<HomeViewModel, AttendanceModel>(
  HomeViewModel.new,
);