import 'package:fpdart/fpdart.dart';
import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';
import 'package:zkp_app/app/utils/failure.dart';

abstract interface class StudentHomeRepo {
  Future<Either<Failure, List<ClassroomEntity>>> getClassrooms();

  Future<Either<Failure, List<ClassroomEntity>>> getClassroomsForStudent({
    required String token,
  });

  Future<Either<Failure, String>> joinClassroom({
    required String token,
    required String classroomId,
  });
}
