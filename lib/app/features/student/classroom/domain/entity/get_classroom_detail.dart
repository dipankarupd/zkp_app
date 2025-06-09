class StudentClassroomDetailEntity {
  final String id;
  final int absentCount;
  final int presentCount;
  final String name;
  final int totalClassTaken;

  StudentClassroomDetailEntity({
    required this.id,
    required this.absentCount,
    required this.presentCount,
    required this.name,
    required this.totalClassTaken,
  });
}
