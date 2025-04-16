import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sec_learning/features/curriculum/bloc/curriculum_event.dart';
import 'package:sec_learning/features/curriculum/bloc/curriculum_state.dart';
import 'package:sec_learning/features/curriculum/data/curriculum_repository.dart';

class CurriculumBloc extends Bloc<CurriculumEvent, CurriculumState> {
  final CurriculumRepository repository;

  CurriculumBloc({required this.repository}) : super(CurriculumInitial()) {
    on<LoadCurriculum>(_onLoadCurriculum);
    on<AddCurriculum>(_onAddCurriculum);
    on<UpdateCurriculum>(_onUpdateCurriculum);
    on<DeleteCurriculum>(_onDeleteCurriculum);
    on<FilterCurriculumByGrade>(_onFilterCurriculumByGrade);
  }

  Future<void> _onLoadCurriculum(
    LoadCurriculum event,
    Emitter<CurriculumState> emit,
  ) async {
    emit(CurriculumLoading());
    try {
      final curricula = await repository.getCurriculum();
      emit(CurriculumLoaded(curricula: curricula));
    } catch (e) {
      emit(CurriculumError('Failed to load curriculum: ${e.toString()}'));
    }
  }

  Future<void> _onAddCurriculum(
    AddCurriculum event,
    Emitter<CurriculumState> emit,
  ) async {
    if (state is CurriculumLoaded) {
      try {
        await repository.addCurriculum(event.curriculum);
        final curricula = await repository.getCurriculum();
        emit(
          CurriculumLoaded(
            curricula: curricula,
            filteredGrade: (state as CurriculumLoaded).filteredGrade,
          ),
        );
        emit(CurriculumOperationSuccess('تم إضافة المنهج بنجاح'));
      } catch (e) {
        emit(CurriculumError('Failed to add curriculum: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateCurriculum(
    UpdateCurriculum event,
    Emitter<CurriculumState> emit,
  ) async {
    if (state is CurriculumLoaded) {
      try {
        await repository.updateCurriculum(event.curriculum);
        final curricula = await repository.getCurriculum();
        emit(
          CurriculumLoaded(
            curricula: curricula,
            filteredGrade: (state as CurriculumLoaded).filteredGrade,
          ),
        );
        emit(CurriculumOperationSuccess('تم تحديث المنهج بنجاح'));
      } catch (e) {
        emit(CurriculumError('Failed to update curriculum: ${e.toString()}'));
      }
    }
  }

  Future<void> _onDeleteCurriculum(
    DeleteCurriculum event,
    Emitter<CurriculumState> emit,
  ) async {
    if (state is CurriculumLoaded) {
      try {
        await repository.deleteCurriculum(event.curriculumId);
        final curricula = await repository.getCurriculum();
        emit(
          CurriculumLoaded(
            curricula: curricula,
            filteredGrade: (state as CurriculumLoaded).filteredGrade,
          ),
        );
        emit(CurriculumOperationSuccess('تم حذف المنهج بنجاح'));
      } catch (e) {
        emit(CurriculumError('Failed to delete curriculum: ${e.toString()}'));
      }
    }
  }

  Future<void> _onFilterCurriculumByGrade(
    FilterCurriculumByGrade event,
    Emitter<CurriculumState> emit,
  ) async {
    if (state is CurriculumLoaded) {
      final currentState = state as CurriculumLoaded;
      if (event.grade.isEmpty) {
        emit(
          CurriculumLoaded(
            curricula: await repository.getCurriculum(),
            filteredGrade: null,
          ),
        );
      } else {
        final filtered =
            currentState.curricula
                .where((c) => c.grade == event.grade)
                .toList();
        emit(CurriculumLoaded(curricula: filtered, filteredGrade: event.grade));
      }
    }
  }
}
