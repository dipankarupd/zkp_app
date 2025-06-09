class ClassroomDetailEntity {
  final int classesConducted;
  final DateTime createdAt;
  final String description;
  final String id;
  final String name;
  final List<Student> students;
  final String teacherName;
  final int totalStudents;

  ClassroomDetailEntity({
    required this.classesConducted,
    required this.createdAt,
    required this.description,
    required this.id,
    required this.name,
    required this.students,
    required this.teacherName,
    required this.totalStudents,
  });
}

class Student {
  final String id;
  final String name;
  final int presentCount;
  final int absentCount;
  final double attendancePercentage;

  Student({
    required this.id,
    required this.name,
    required this.presentCount,
    required this.absentCount,
    required this.attendancePercentage,
  });
}
