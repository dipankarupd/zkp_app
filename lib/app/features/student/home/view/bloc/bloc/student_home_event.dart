part of 'student_home_bloc.dart';

abstract class StudentHomeEvent {}

class FetchClassroomsEvent extends StudentHomeEvent {
  final String token;

  FetchClassroomsEvent({required this.token});
}

class ChangeFilterEvent extends StudentHomeEvent {
  final ClassroomFilter filter;
  final String token;

  ChangeFilterEvent({required this.filter, required this.token});
}

class JoinClassroomEvent extends StudentHomeEvent {
  final String classroomId;
  final String token;

  JoinClassroomEvent({
    required this.classroomId,
    required this.token,
  });
}
