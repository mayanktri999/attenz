import 'package:go_router/go_router.dart';

import '../../core/router/main_shell.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/attendance/presentation/screens/attendance_screen.dart';
import '../../features/attendance/presentation/screens/attendance_details_screen.dart';
import '../../features/timetable/presentation/screens/timetable_screen.dart';
import '../../features/store/presentation/screens/store_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // ── Auth routes (no bottom nav shell) ─────────────────────
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // ── Main shell (bottom nav) ────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),

        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),

          GoRoute(
            path: '/attendance',
            builder: (context, state) => const AttendanceScreen(),
          ),

          GoRoute(
            path: '/attendance/:subjectId',
            builder: (context, state) {
              final subjectId = state.pathParameters['subjectId']!;
              return AttendanceDetailsScreen(subjectId: subjectId);
            },
          ),

          GoRoute(
            path: '/store',
            builder: (context, state) => const StoreScreen(),
          ),

          GoRoute(
            path: '/store/:subjectCode',
            builder: (context, state) {
              final subjectCode = state.pathParameters['subjectCode']!;
              return SubjectStoreScreen(subjectCode: subjectCode);
            },
          ),

          GoRoute(
            path: '/timetable',
            builder: (context, state) => const TimetableScreen(),
          ),

          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
