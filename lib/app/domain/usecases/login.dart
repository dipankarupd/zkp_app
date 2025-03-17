import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/domain/entity/register_user_entity.dart';
import 'package:zkp_app/app/domain/repository/app_repository.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class Login implements Usecase<UserEntity, LoginParams> {
  final AppRepository repository;

  Login({required this.repository});
  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.login(token: params.token);
  }
}

class LoginParams {
  final String token;

  LoginParams({required this.token});
}
