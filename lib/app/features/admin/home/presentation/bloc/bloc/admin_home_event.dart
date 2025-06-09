part of 'admin_home_bloc.dart';

abstract class AdminHomeEvent {}

class FetchClassroomsEvent extends AdminHomeEvent {
  final String token;

  FetchClassroomsEvent({required this.token});
}

class CreateClassroomEvent extends AdminHomeEvent {
  final String name;
  final String description;
  final String teacherName;

  CreateClassroomEvent({
    required this.name,
    required this.description,
    required this.teacherName,
  });
}
