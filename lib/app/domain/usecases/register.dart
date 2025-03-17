import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/domain/entity/register_user_entity.dart';
import 'package:zkp_app/app/domain/repository/app_repository.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class Register implements Usecase<UserEntity, RegisterParams> {
  final AppRepository repo;

  Register({required this.repo});

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
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
