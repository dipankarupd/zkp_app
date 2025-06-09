import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/classs_entity.dart';
import 'package:zkp_app/app/features/student/classroom/domain/repo/classroom_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class GetUpcomingClass implements Usecase<ClassEntity, GetUpcomingClassParams> {
  final StudentClassroomRepo repo;

  GetUpcomingClass({required this.repo});
  @override
  Future<Either<Failure, ClassEntity>> call(
      GetUpcomingClassParams params) async {
    return await repo.getUpcomingClass(classroomId: params.classroomId);
  }
}

class GetUpcomingClassParams {
  final String classroomId;

  GetUpcomingClassParams({required this.classroomId});
}
