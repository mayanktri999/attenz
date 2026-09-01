import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _studentKey = 'student_number';

/// Notifier that holds the student number for the current session.
class CurrentStudentNotifier extends Notifier<String?> {
  @override
  String? build() {
    _loadPersistedStudent();
    return null;
  }

  Future<void> _loadPersistedStudent() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_studentKey);
  }

  Future<void> setStudentNumber(String studentNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studentKey, studentNumber);
    state = studentNumber;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_studentKey);
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
