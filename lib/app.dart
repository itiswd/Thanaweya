import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sec_learning/core/supabase_init.dart';
import 'package:sec_learning/features/auth/bloc/auth_bloc.dart';
import 'package:sec_learning/features/auth/data/auth_repository.dart';
import 'package:sec_learning/features/auth/presentation/login_screen.dart';
import 'package:sec_learning/features/curriculum/bloc/curriculum_bloc.dart';
import 'package:sec_learning/features/curriculum/bloc/curriculum_event.dart';
import 'package:sec_learning/features/curriculum/data/curriculum_repository.dart';
import 'package:sec_learning/features/home/presentation/home_screen.dart';
import 'package:sec_learning/features/student/presentation/student_home.dart';
import 'package:sec_learning/features/teacher/presentation/teacher_dashboard.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (context) =>
                  AuthBloc(authRepository: AuthRepository())
                    ..add(CheckAuthEvent()),
        ),

        BlocProvider<CurriculumBloc>(
          create:
              (context) =>
                  CurriculumBloc(repository: CurriculumRepository())
                    ..add(LoadCurriculum()),
        ),
      ],
      child: MaterialApp(
        title: 'ثانوية عامة',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Tajawal',
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is AuthAuthenticated) {
              // تمرير user إلى HomeScreen
              return HomeScreen(user: state.user);
            }

            if (state is AuthUnauthenticated) {
              return LoginScreen();
            }

            return const Scaffold(
              body: Center(child: Text('حدث خطأ غير متوقع')),
            );
          },
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) {
            final user = context.read<AuthBloc>().state;
            if (user is AuthAuthenticated) {
              return HomeScreen(user: user.user);
            }
            return LoginScreen();
          },
          '/student': (context) => const StudentHome(),
          '/teacher': (context) => const TeacherDashboard(),
        },
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder:
                (context) => const Scaffold(
                  body: Center(child: Text('الصفحة غير موجودة')),
                ),
          );
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseInit.initialize();
  runApp(const App());
}
