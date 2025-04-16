import 'package:flutter/material.dart';
import 'package:sec_learning/features/auth/domain/user_model.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // تنفيذ عملية تسجيل الخروج
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('مرحباً ${user.name ?? user.email}'),
            const SizedBox(height: 20),
            if (user.role == 'teacher')
              ElevatedButton(
                onPressed: () {
                  // الانتقال إلى لوحة التحكم للمدرسين
                },
                child: const Text('لوحة التحكم'),
              ),
          ],
        ),
      ),
    );
  }
}
