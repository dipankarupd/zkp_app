import 'package:zkp_app/app/features/admin/home/domain/entity/classroom_detail_entity.dart';

class ClassroomDetailModel extends ClassroomDetailEntity {
  ClassroomDetailModel({
    required super.classesConducted,
    required super.createdAt,
    required super.description,
    required super.id,
    required super.name,
    required List<StudentModel> super.students,
    required super.teacherName,
    required super.totalStudents,
  });

  factory ClassroomDetailModel.fromJson(Map<String, dynamic> json) {
    return ClassroomDetailModel(
      classesConducted: json['classes_conducted'],
      createdAt: DateTime.parse(json['created_at']),
      description: json['description'],
      id: json['id'],
      name: json['name'],
      students: (json['students'] as List<dynamic>?)
              ?.map((x) => StudentModel.fromJson(x))
              .toList() ??
          [],
      teacherName: json['teacher_name'],
      totalStudents: json['total_students'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classes_conducted': classesConducted,
      'created_at': createdAt.toIso8601String(),
      'description': description,
      'id': id,
      'name': name,
      'students': students.map((s) => (s as StudentModel).toJson()).toList(),
      'teacher_name': teacherName,
      'total_students': totalStudents,
    };
  }
}

class StudentModel extends Student {
  StudentModel({
    required super.id,
    required super.name,
    required super.presentCount,
    required super.absentCount,
    required super.attendancePercentage,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      presentCount: json['present_count'],
      absentCount: json['absent_count'],
      attendancePercentage: (json['attendance_percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'present_count': presentCount,
      'absent_count': absentCount,
      'attendance_percentage': attendancePercentage,
    };
  }
}
