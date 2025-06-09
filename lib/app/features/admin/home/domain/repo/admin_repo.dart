import 'package:fpdart/fpdart.dart';
import 'package:zkp_app/app/features/admin/home/domain/entity/classroom_detail_entity.dart';
import 'package:zkp_app/app/utils/failure.dart';

abstract interface class AdminRepo {
  Future<Either<Failure, String>> createClassroom({
    required String name,
    required String description,
    required String teacherName,
  });

  Future<Either<Failure, ClassroomDetailEntity>> getClassroomDetail({
    required String classroomId,
  });

  Future<Either<Failure, String>> createClass({
    required DateTime startTime,
    required DateTime endTime,
    required String meetLink,
    required String classroomId,
  });
}
