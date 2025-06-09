import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';

class ClassroomModel extends ClassroomEntity {
  ClassroomModel({
    required super.id,
    required super.name,
    required super.description,
    required super.teacherName,
    required super.createdAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'teacher_name': teacherName,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ClassroomModel.fromJson(Map<String, dynamic> map) {
    return ClassroomModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      teacherName: map['teacher_name'] as String,
      createdAt: DateTime.parse(map['created_at'] ?? ''),
    );
  }
}
