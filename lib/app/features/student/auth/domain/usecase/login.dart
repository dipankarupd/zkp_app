import 'package:fpdart/fpdart.dart';
import 'package:zkp_app/app/features/student/auth/domain/entity/student_entity.dart';
import 'package:zkp_app/app/features/student/auth/domain/repo/user_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class Login implements Usecase<StudentEntity, LoginParams> {
  final UserRepo repository;

  Login({required this.repository});
  @override
  Future<Either<Failure, StudentEntity>> call(LoginParams params) async {
    return await repository.login(token: params.token);
  }
}

class LoginParams {
  final String token;

  LoginParams({required this.token});
}
