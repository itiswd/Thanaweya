import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sec_learning/features/auth/bloc/auth_bloc.dart';
import 'package:sec_learning/features/auth/presentation/login_screen.dart'
    show LoginScreen;
import 'package:sec_learning/features/auth/presentation/register_screen.dart'
    show RegisterScreen;
import 'package:sec_learning/features/home/presentation/home_screen.dart'
    show HomeScreen;
import 'package:sec_learning/features/settings/presentation/settings_screen.dart'
    show SettingsScreen;
import 'package:sec_learning/features/student/presentation/student_home.dart'
    show StudentHome;
import 'package:sec_learning/features/teacher/presentation/teacher_dashboard.dart'
    show TeacherDashboard;

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder:
              (_) => BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return HomeScreen(user: state.user);
                  }
                  return LoginScreen();
                },
              ),
        );
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/student':
        return MaterialPageRoute(
          builder:
              (_) => BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return StudentHome();
                  }
                  return LoginScreen();
                },
              ),
        );
      case '/teacher':
        return MaterialPageRoute(
          builder:
              (_) => BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated &&
                      state.user.role == 'teacher') {
                    return const TeacherDashboard();
                  }
                  return LoginScreen();
                },
              ),
        );
      case '/settings':
        return MaterialPageRoute(
          builder:
              (_) => BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return SettingsScreen();
                  }
                  return LoginScreen();
                },
              ),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(child: Text('لا يوجد مسار لـ ${settings.name}')),
              ),
        );
    }
  }
}
