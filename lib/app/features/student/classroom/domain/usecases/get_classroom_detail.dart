import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/get_classroom_detail.dart';
import 'package:zkp_app/app/features/student/classroom/domain/repo/classroom_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class GetClassroomDetail
    implements
        Usecase<StudentClassroomDetailEntity, GetClassroomDetailUsecaseParams> {
  final StudentClassroomRepo repo;

  GetClassroomDetail({required this.repo});
  @override
  Future<Either<Failure, StudentClassroomDetailEntity>> call(
      GetClassroomDetailUsecaseParams params) async {
    return await repo.getMyDetail(
      token: params.token,
      classroomId: params.classroomId,
    );
  }
}

class GetClassroomDetailUsecaseParams {
  final String token;
  final String classroomId;

  GetClassroomDetailUsecaseParams({
    required this.token,
    required this.classroomId,
  });
}
