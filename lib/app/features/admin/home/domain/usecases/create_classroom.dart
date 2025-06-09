import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/features/admin/home/domain/repo/admin_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class CreateClassroom implements Usecase<String, CreateClassParams> {
  final AdminRepo repo;

  CreateClassroom({required this.repo});
  @override
  Future<Either<Failure, String>> call(CreateClassParams params) async {
    return await repo.createClassroom(
      name: params.name,
      description: params.description,
      teacherName: params.teachername,
    );
  }
}

class CreateClassParams {
  final String name;
  final String description;
  final String teachername;

  CreateClassParams({
    required this.name,
    required this.description,
    required this.teachername,
  });
}
