import 'package:zkp_app/app/features/student/classroom/domain/entity/result_entity.dart';

class ResultModel extends ResultEntity {
  ResultModel({required super.result});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'result': result,
    };
  }

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    return ResultModel(
      result: map['result'] as String,
    );
  }
}
