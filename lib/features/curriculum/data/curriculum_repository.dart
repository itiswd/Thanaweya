import 'package:sec_learning/core/supabase_init.dart';
import 'package:sec_learning/features/curriculum/domain/curriculum_model.dart';

class CurriculumRepository {
  final _supabase = SupabaseInit.client;

  Future<List<CurriculumModel>> getCurriculum() async {
    final response = await _supabase
        .from('curricula')
        .select()
        .order('grade', ascending: true);

    return (response as List)
        .map((json) => CurriculumModel.fromJson(json))
        .toList();
  }

  Future<void> addCurriculum(CurriculumModel curriculum) async {
    await _supabase.from('curricula').insert({
      'subject': curriculum.subject,
      'grade': curriculum.grade,
      'description': curriculum.description,
      'image_url': curriculum.imageUrl,
    });
  }

  Future<void> updateCurriculum(CurriculumModel curriculum) async {
    await _supabase
        .from('curricula')
        .update({
          'subject': curriculum.subject,
          'grade': curriculum.grade,
          'description': curriculum.description,
          'image_url': curriculum.imageUrl,
        })
        .eq('id', curriculum.id);
  }

  Future<void> deleteCurriculum(int curriculumId) async {
    await _supabase.from('curricula').delete().eq('id', curriculumId);
  }
}
