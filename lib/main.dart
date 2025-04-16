import 'package:flutter/material.dart';
import 'package:sec_learning/app_router.dart' show AppRouter;
import 'package:sec_learning/core/supabase_init.dart' show SupabaseInit;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseInit.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ثانوية عامة',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Tajawal'),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
