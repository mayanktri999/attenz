import 'package:go_router/go_router.dart';
import '../../core/router/main_shell.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/attendance/presentation/screens/attendance_screen.dart';
import '../../features/attendance/presentation/screens/attendance_details_screen.dart';
import '../../features/timetable/presentation/screens/timetable_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/chat/presentation/screens/group_chat_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/splash',

    routes: [

      ShellRoute(
  builder: (context, state, child) {
    return MainShell(
      child: child,
    );
  },

  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),

    GoRoute(
      path: '/chat',
      builder: (context, state) {
        return const ChatScreen();
      },
    ),

    GoRoute(
      path: '/timetable',
      builder: (context, state) {
        return const TimetableScreen();
      },
    ),

    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return const ProfileScreen();
      },
    ),
  ],
),
      GoRoute(
        path: '/splash',
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) {
          return const HomeScreen();
        },
      ),

      GoRoute(
        path: '/attendance',
        builder: (context, state) {
          return const AttendanceScreen();
        },
      ),

       
      GoRoute(
        path: '/attendance/:subjectId',
        builder: (context, state) {
          final subjectId = state.pathParameters['subjectId']!;

          return AttendanceDetailsScreen(
            subjectId: subjectId,
          );
        },
      ),
      

      GoRoute(
        path: '/timetable',
        builder: (context, state) {
          return const TimetableScreen();
        },
      ),

      GoRoute(
        path: '/chat',
        builder: (context, state) {
          return const ChatScreen();
        },
      ),

      GoRoute(
        path: '/chat/:groupId',
        builder: (context, state) {
          final groupId = state.pathParameters['groupId']!;

          return GroupChatScreen(
            groupId: groupId,
          );
        },
      ),

      GoRoute(
        path: '/profile',
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),

      GoRoute(
        path: '/settings',
        builder: (context, state) {
          return const SettingsScreen();
        },
      ),
    ],
  );
}