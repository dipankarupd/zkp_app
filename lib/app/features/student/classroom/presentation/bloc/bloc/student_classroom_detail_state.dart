part of 'student_classroom_detail_bloc.dart';

enum UpcomingClassStatus { initial, loading, loaded, error, noClass }

@immutable
sealed class StudentClassroomDetailState {}

final class StudentClassroomDetailInitial extends StudentClassroomDetailState {}

class ClassroomDetailLoading extends StudentClassroomDetailState {}

class ClassroomDetailLoaded extends StudentClassroomDetailState {
  final StudentClassroomDetailEntity classroom;
  final ClassEntity? upcomingClass;
  final UpcomingClassStatus upcomingClassStatus;
  final String? upcomingClassError;

  ClassroomDetailLoaded({
    required this.classroom,
    this.upcomingClass,
    this.upcomingClassStatus = UpcomingClassStatus.initial,
    this.upcomingClassError,
  });
}

class ClassroomDetailError extends StudentClassroomDetailState {
  final String message;

  ClassroomDetailError({required this.message});
}

class AttendanceMarkingInProgress extends StudentClassroomDetailState {}

class AttendanceMarkedSuccess extends StudentClassroomDetailState {
  final String message;

  AttendanceMarkedSuccess({required this.message});
}

class AttendanceMarkedFailure extends StudentClassroomDetailState {
  final String error;

  AttendanceMarkedFailure({required this.error});
}
