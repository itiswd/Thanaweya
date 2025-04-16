import 'package:equatable/equatable.dart';
import 'package:sec_learning/features/curriculum/domain/curriculum_model.dart';

abstract class CurriculumState extends Equatable {
  const CurriculumState();

  @override
  List<Object> get props => [];
}

class CurriculumInitial extends CurriculumState {}

class CurriculumLoading extends CurriculumState {}

class CurriculumLoaded extends CurriculumState {
  final List<CurriculumModel> curricula;
  final String? filteredGrade;

  const CurriculumLoaded({required this.curricula, this.filteredGrade});

  @override
  List<Object> get props => [curricula, filteredGrade ?? ''];
}

class CurriculumOperationSuccess extends CurriculumState {
  final String message;

  const CurriculumOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class CurriculumError extends CurriculumState {
  final String message;

  const CurriculumError(this.message);

  @override
  List<Object> get props => [message];
}
