import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/features/student/home/data/model/classroom_model.dart';
import 'package:zkp_app/app/features/student/home/data/source/home_data_source.dart';
import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';
import 'package:zkp_app/app/features/student/home/domain/repo/home_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';

class StudentHomeRepoImpl implements StudentHomeRepo {
  final StudentHomeDataSource source;

  StudentHomeRepoImpl({
    required this.source,
  });

  @override
  Future<Either<Failure, List<ClassroomEntity>>> getClassrooms() async {
    try {
      List<ClassroomModel> classrooms = await source.getClassrooms();
      return right(classrooms);
    } catch (e) {
      return Left(
        Failure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<ClassroomEntity>>> getClassroomsForStudent({
    required String token,
  }) async {
    try {
      List<ClassroomModel> classroom =
          await source.getClassroomsForStudent(token: token);
      return right(classroom);
    } catch (e) {
      return Left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> joinClassroom(
      {required String token, required String classroomId}) async {
    try {
      String resp = await source.joinClassroom(
        classroomId: classroomId,
        token: token,
      );
      return right(resp);
    } catch (e) {
      return left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }
}
