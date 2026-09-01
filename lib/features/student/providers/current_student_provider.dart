import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier that holds the student number for the current session.
class CurrentStudentNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setStudentNumber(String studentNumber) {
    state = studentNumber;
  }

  void clear() {
    state = null;
  }
}

/// Provides the current student's student number.
///
/// Set on login; read by [attendanceProvider] and any other
/// provider that needs the current student's identity.
///
/// Null means no student is logged in.
final currentStudentNumberProvider =
    NotifierProvider<CurrentStudentNotifier, String?>(
  CurrentStudentNotifier.new,
);
