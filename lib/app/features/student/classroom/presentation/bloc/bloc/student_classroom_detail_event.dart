part of 'student_classroom_detail_bloc.dart';

abstract class StudentClassroomDetailEvent {}

class ClassroomDetailFetched extends StudentClassroomDetailEvent {
  final String token;
  final String classroomId;

  ClassroomDetailFetched({
    required this.token,
    required this.classroomId,
  });
}

class UpcomingClassFetched extends StudentClassroomDetailEvent {
  final String classroomId;

  UpcomingClassFetched({
    required this.classroomId,
  });
}

class MarkAttendanceRequested extends StudentClassroomDetailEvent {
  final String token;
  final String classId;
  final double latitude;
  final double longitude;

  MarkAttendanceRequested({
    required this.token,
    required this.classId,
    required this.latitude,
    required this.longitude,
  });
}
