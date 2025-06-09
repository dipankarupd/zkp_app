import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/features/admin/home/domain/repo/admin_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class CreateClass implements Usecase<String, CreateClassParams> {
  final AdminRepo repo;

  CreateClass({required this.repo});

  @override
  Future<Either<Failure, String>> call(CreateClassParams params) async {
    return await repo.createClass(
      startTime: params.startTime,
      endTime: params.endTime,
      meetLink: params.meetLink,
      classroomId: params.classroomId,
    );
  }
}

class CreateClassParams {
  final DateTime startTime;
  final DateTime endTime;
  final String meetLink;
  final String classroomId;

  CreateClassParams({
    required this.startTime,
    required this.endTime,
    required this.meetLink,
    required this.classroomId,
  });
}
