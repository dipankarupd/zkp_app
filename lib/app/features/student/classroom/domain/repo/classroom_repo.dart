import 'package:fpdart/fpdart.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/classs_entity.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/get_classroom_detail.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/result_entity.dart';
import 'package:zkp_app/app/utils/failure.dart';

abstract interface class StudentClassroomRepo {
  Future<Either<Failure, StudentClassroomDetailEntity>> getMyDetail({
    required String token,
    required String classroomId,
  });
  Future<Either<Failure, ClassEntity>> getUpcomingClass({
    required String classroomId,
  });
  Future<Either<Failure, String>> markAttendance({
    required String classId,
    required String studentToken,
    required bool isPresent,
  });
  Future<Either<Failure, ResultEntity>> verifyResult({
    required int distance,
  });
}
