import 'package:flutter/material.dart';
import 'package:sec_learning/features/content/presentation/content_list.dart'
    show ContentList;
import 'package:sec_learning/features/curriculum/presentation/curriculum_screen.dart'
    show CurriculumScreen;

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الطالب'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.book)),
              Tab(icon: Icon(Icons.assignment)),
              Tab(icon: Icon(Icons.schedule)),
              Tab(icon: Icon(Icons.video_library)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CurriculumScreen(),
            ContentList(title: 'الاختبارات', collectionName: 'exams'),
            ContentList(title: 'الجداول', collectionName: 'schedules'),
            ContentList(title: 'المحاضرات', collectionName: 'lectures'),
          ],
        ),
      ),
    );
  }
}
