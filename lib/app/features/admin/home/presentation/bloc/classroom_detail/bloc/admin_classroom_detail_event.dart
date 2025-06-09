part of 'admin_classroom_detail_bloc.dart';

abstract class AdminClassroomDetailEvent {}

class FetchClassroomDetailEvent extends AdminClassroomDetailEvent {
  final String classroomId;

  FetchClassroomDetailEvent({required this.classroomId});
}

class CreateClassEvent extends AdminClassroomDetailEvent {
  final DateTime startTime;
  final DateTime endTime;
  final String meetLink;
  final String classroomId;

  CreateClassEvent({
    required this.startTime,
    required this.endTime,
    required this.meetLink,
    required this.classroomId,
  });
}

// New event to clear error messages
class ClearErrorMessageEvent extends AdminClassroomDetailEvent {}
