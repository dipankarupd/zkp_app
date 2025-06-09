part of 'admin_home_bloc.dart';

enum ClassroomStatus { initial, loading, success, failure }

enum AddClassroomStatus { initial, loading, success, failure }

class AdminHomeState {
  final ClassroomStatus status;
  final List<ClassroomEntity> classrooms;
  final String? errorMessage;

  // For add classroom operation
  final AddClassroomStatus addStatus;
  final String? addMessage;

  const AdminHomeState({
    required this.status,
    required this.classrooms,
    this.errorMessage,
    required this.addStatus,
    this.addMessage,
  });

  factory AdminHomeState.initial() => const AdminHomeState(
        status: ClassroomStatus.initial,
        classrooms: [],
        addStatus: AddClassroomStatus.initial,
      );

  AdminHomeState copyWith({
    ClassroomStatus? status,
    List<ClassroomEntity>? classrooms,
    String? errorMessage,
    AddClassroomStatus? addStatus,
    String? addMessage,
  }) {
    return AdminHomeState(
      status: status ?? this.status,
      classrooms: classrooms ?? this.classrooms,
      errorMessage: errorMessage ?? this.errorMessage,
      addStatus: addStatus ?? this.addStatus,
      addMessage: addMessage ?? this.addMessage,
    );
  }
}
