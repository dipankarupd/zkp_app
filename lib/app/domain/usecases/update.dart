import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/domain/entity/register_user_entity.dart';
import 'package:zkp_app/app/domain/repository/app_repository.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class Update implements Usecase<UserEntity, UpdateParams> {
  final AppRepository repository;

  Update({required this.repository});
  @override
  Future<Either<Failure, UserEntity>> call(UpdateParams params) async {
    return await repository.updateUser(
      token: params.token,
      date: params.date,
      isPresent: params.isPresent,
    );
  }
}

class UpdateParams {
  final String token;
  final String date;
  final bool isPresent;

  UpdateParams({
    required this.token,
    required this.date,
    required this.isPresent,
  });
}
