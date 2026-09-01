import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/attendance/data/models/attendance_model.dart';
import '/features/attendance/data/providers/attendance_providers.dart';

/// ViewModel for the Home screen.
///
/// Exposes [AttendanceModel] directly from the attendance provider.
/// The UI reads real backend data — no mock data is used.
class HomeViewModel extends AsyncNotifier<AttendanceModel> {
  @override
  Future<AttendanceModel> build() async {
    // Watch the attendance provider — automatically re-builds
    // when the student number changes or when invalidated.
    return ref.watch(attendanceProvider.future);
  }

  /// Invalidates the attendance provider to trigger a fresh network request.
  Future<void> refreshHome() async {
    state = const AsyncLoading();
    ref.invalidate(attendanceProvider);
    state = await AsyncValue.guard(
      () => ref.read(attendanceProvider.future),
    );
  }
}