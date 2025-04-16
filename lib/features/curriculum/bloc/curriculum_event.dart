import 'package:equatable/equatable.dart';
import 'package:sec_learning/features/curriculum/domain/curriculum_model.dart';

abstract class CurriculumEvent extends Equatable {
  const CurriculumEvent();

  @override
  List<Object> get props => [];
}

class LoadCurriculum extends CurriculumEvent {}

class AddCurriculum extends CurriculumEvent {
  final CurriculumModel curriculum;

  const AddCurriculum(this.curriculum);

  @override
  List<Object> get props => [curriculum];
}

class UpdateCurriculum extends CurriculumEvent {
  final CurriculumModel curriculum;

  const UpdateCurriculum(this.curriculum);

  @override
  List<Object> get props => [curriculum];
}

class DeleteCurriculum extends CurriculumEvent {
  final int curriculumId;

  const DeleteCurriculum(this.curriculumId);

  @override
  List<Object> get props => [curriculumId];
}

class FilterCurriculumByGrade extends CurriculumEvent {
  final String grade;

  const FilterCurriculumByGrade(this.grade);

  @override
  List<Object> get props => [grade];
}
