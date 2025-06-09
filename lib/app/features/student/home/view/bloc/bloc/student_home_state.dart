part of 'student_home_bloc.dart';

enum ClassroomStatus { initial, loading, success, failure }

enum JoinClassroomStatus { initial, loading, success, failure }

enum ClassroomFilter { all, joined }

class StudentHomeState {
  final ClassroomStatus status;
  final List<ClassroomEntity> classrooms;
  final ClassroomFilter filter;
  final String? errorMessage;

  // For join classroom operation
  final JoinClassroomStatus joinStatus;
  final String? joinMessage;

  const StudentHomeState({
    required this.status,
    required this.classrooms,
    required this.filter,
    this.errorMessage,
    required this.joinStatus,
    this.joinMessage,
  });

  factory StudentHomeState.initial() => const StudentHomeState(
        status: ClassroomStatus.initial,
        classrooms: [],
        filter: ClassroomFilter.all,
        joinStatus: JoinClassroomStatus.initial,
      );

  StudentHomeState copyWith({
    ClassroomStatus? status,
    List<ClassroomEntity>? classrooms,
    ClassroomFilter? filter,
    String? errorMessage,
    JoinClassroomStatus? joinStatus,
    String? joinMessage,
  }) {
    return StudentHomeState(
      status: status ?? this.status,
      classrooms: classrooms ?? this.classrooms,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
      joinStatus: joinStatus ?? this.joinStatus,
      joinMessage: joinMessage ?? this.joinMessage,
    );
  }
}
