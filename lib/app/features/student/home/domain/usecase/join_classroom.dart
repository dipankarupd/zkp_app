import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/features/student/home/domain/repo/home_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class JoinClassroom implements Usecase<String, JoinClassroomUsecaseParams> {
  final StudentHomeRepo repo;

  JoinClassroom({required this.repo});
  @override
  Future<Either<Failure, String>> call(
      JoinClassroomUsecaseParams params) async {
    return await repo.joinClassroom(
      token: params.token,
      classroomId: params.classroomId,
    );
  }
}

class JoinClassroomUsecaseParams {
  final String token;
  final String classroomId;

  JoinClassroomUsecaseParams({
    required this.token,
    required this.classroomId,
  });
}
