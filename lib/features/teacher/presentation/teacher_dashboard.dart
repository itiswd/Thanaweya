import 'package:flutter/material.dart';
import 'package:sec_learning/features/teacher/presentation/upload_content_screen.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة التحكم')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildDashboardItem(
            context,
            icon: Icons.upload,
            label: 'رفع محتوى',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UploadContentScreen(),
                  ),
                ),
          ),
          _buildDashboardItem(
            context,
            icon: Icons.assignment,
            label: 'الاختبارات',
            onTap: () {},
          ),
          _buildDashboardItem(
            context,
            icon: Icons.schedule,
            label: 'الجداول',
            onTap: () {},
          ),
          _buildDashboardItem(
            context,
            icon: Icons.video_library,
            label: 'المحاضرات',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
