part of 'admin_classroom_detail_bloc.dart';

enum ClassroomDetailStatus { initial, loading, success, failure }

class AdminClassroomDetailState {
  final ClassroomDetailStatus status;
  final ClassroomDetailEntity? classroomDetail;
  final String? errorMessage;
  final String? successMessage; // Added for success notifications

  const AdminClassroomDetailState({
    required this.status,
    this.classroomDetail,
    this.errorMessage,
    this.successMessage,
  });

  factory AdminClassroomDetailState.initial() =>
      const AdminClassroomDetailState(
        status: ClassroomDetailStatus.initial,
      );

  AdminClassroomDetailState copyWith({
    ClassroomDetailStatus? status,
    ClassroomDetailEntity? classroomDetail,
    String? errorMessage,
    String? successMessage,
  }) {
    return AdminClassroomDetailState(
      status: status ?? this.status,
      classroomDetail: classroomDetail ?? this.classroomDetail,
      errorMessage:
          errorMessage, // Intentionally not using ?? operator to allow null
      successMessage:
          successMessage, // Intentionally not using ?? operator to allow null
    );
  }
}
