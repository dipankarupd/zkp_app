import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';
import 'package:zkp_app/app/features/student/home/domain/repo/home_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class GetClassroomForStudent
    implements Usecase<List<ClassroomEntity>, GetClassroomForStudentParams> {
  final StudentHomeRepo repo;

  GetClassroomForStudent({required this.repo});
  @override
  Future<Either<Failure, List<ClassroomEntity>>> call(
      GetClassroomForStudentParams params) async {
    return await repo.getClassroomsForStudent(token: params.token);
  }
}

class GetClassroomForStudentParams {
  final String token;

  GetClassroomForStudentParams({
    required this.token,
  });
}
