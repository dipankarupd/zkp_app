import 'package:zkp_app/app/features/student/classroom/domain/entity/classs_entity.dart';

class ClassModel extends ClassEntity {
  ClassModel({
    required super.id,
    required super.classroomId,
    required super.startTime,
    required super.endTime,
    required super.meetLink,
    required super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'classroom_id': classroomId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'meet_link': meetLink,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] as String,
      classroomId: map['classroom_id'] as String,
      startTime: DateTime.parse(map['start_time'] as String),
      endTime: DateTime.parse(map['end_time'] as String),
      meetLink: map['meet_link'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
