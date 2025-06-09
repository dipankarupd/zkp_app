class ClassEntity {
  final String id;
  final String classroomId;
  final DateTime startTime;
  final DateTime endTime;
  final String meetLink;
  final DateTime createdAt;

  ClassEntity({
    required this.id,
    required this.classroomId,
    required this.startTime,
    required this.endTime,
    required this.meetLink,
    required this.createdAt,
  });
}
