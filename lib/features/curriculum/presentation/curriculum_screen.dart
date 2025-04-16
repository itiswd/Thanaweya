import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sec_learning/features/curriculum/bloc/curriculum_bloc.dart';
import 'package:sec_learning/features/curriculum/bloc/curriculum_event.dart';
import 'package:sec_learning/features/curriculum/bloc/curriculum_state.dart';
import 'package:sec_learning/features/curriculum/domain/curriculum_model.dart';

class CurriculumScreen extends StatelessWidget {
  const CurriculumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المناهج الدراسية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showGradeFilterDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCurriculumDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<CurriculumBloc, CurriculumState>(
        listener: (context, state) {
          if (state is CurriculumError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is CurriculumOperationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CurriculumLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CurriculumLoaded) {
            final curricula = state.curricula;
            if (curricula.isEmpty) {
              return const Center(child: Text('لا توجد مناهج متاحة'));
            }
            return ListView.builder(
              itemCount: curricula.length,
              itemBuilder: (context, index) {
                final curriculum = curricula[index];
                return _buildCurriculumItem(context, curriculum);
              },
            );
          }
          return const Center(child: Text('حدث خطأ في تحميل البيانات'));
        },
      ),
    );
  }

  Widget _buildCurriculumItem(
    BuildContext context,
    CurriculumModel curriculum,
  ) {
    return Card(
      child: ListTile(
        leading:
            curriculum.imageUrl != null
                ? CircleAvatar(
                  backgroundImage: NetworkImage(curriculum.imageUrl!),
                )
                : const CircleAvatar(child: Icon(Icons.book)),
        title: Text(curriculum.subject),
        subtitle: Text('الصف ${curriculum.grade}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditDialog(context, curriculum),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context, curriculum.id),
            ),
          ],
        ),
      ),
    );
  }

  void _showGradeFilterDialog(BuildContext context) {
    final grades = ['الصف الأول', 'الصف الثاني', 'الصف الثالث'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تصفية حسب الصف'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...grades.map(
                (grade) => ListTile(
                  title: Text(grade),
                  onTap: () {
                    context.read<CurriculumBloc>().add(
                      FilterCurriculumByGrade(grade),
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('عرض الكل'),
                onTap: () {
                  context.read<CurriculumBloc>().add(
                    FilterCurriculumByGrade(''),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddCurriculumDialog(BuildContext context) {
    // تنفيذ واجهة إضافة منهج جديد
  }

  void _showEditDialog(BuildContext context, CurriculumModel curriculum) {
    // تنفيذ واجهة تعديل المنهج
  }

  void _confirmDelete(BuildContext context, int curriculumId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: const Text('هل أنت متأكد من حذف هذا المنهج؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  context.read<CurriculumBloc>().add(
                    DeleteCurriculum(curriculumId),
                  );
                  Navigator.pop(context);
                },
                child: const Text('حذف'),
              ),
            ],
          ),
    );
  }
}
