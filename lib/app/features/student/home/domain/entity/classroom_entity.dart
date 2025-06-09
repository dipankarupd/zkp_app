class ClassroomEntity {
  final String id;
  final String name;
  final String description;
  final String teacherName;
  final DateTime createdAt;

  ClassroomEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.teacherName,
    required this.createdAt,
  });
}
