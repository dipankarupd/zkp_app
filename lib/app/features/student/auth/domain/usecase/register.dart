import 'package:fpdart/fpdart.dart';
import 'package:zkp_app/app/features/student/auth/domain/entity/student_entity.dart';
import 'package:zkp_app/app/features/student/auth/domain/repo/user_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class Register implements Usecase<StudentEntity, RegisterParams> {
  final UserRepo repo;

  Register({required this.repo});

  @override
  Future<Either<Failure, StudentEntity>> call(RegisterParams params) async {
    return await repo.register(
      username: params.username,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class RegisterParams {
  final String username;
  final double latitude;
  final double longitude;

  RegisterParams({
    required this.username,
    required this.latitude,
    required this.longitude,
  });
}
