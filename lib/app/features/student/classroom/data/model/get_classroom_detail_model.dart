import 'package:zkp_app/app/features/student/classroom/domain/entity/get_classroom_detail.dart';

class StudentClassroomDetailModel extends StudentClassroomDetailEntity {
  StudentClassroomDetailModel({
    required super.id,
    required super.absentCount,
    required super.presentCount,
    required super.name,
    required super.totalClassTaken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'absent_count': absentCount,
      'present_count': presentCount,
      'name': name,
      'total_class_taken': totalClassTaken,
    };
  }

  factory StudentClassroomDetailModel.fromMap(Map<String, dynamic> map) {
    return StudentClassroomDetailModel(
      id: map['id'] as String,
      absentCount: map['absent_count'] as int,
      presentCount: map['present_count'] as int,
      name: map['name'] as String,
      totalClassTaken: map['total_class_taken'] as int,
    );
  }
}
