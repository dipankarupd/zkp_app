import 'package:fpdart/fpdart.dart';
import 'package:zkp_app/app/domain/entity/register_user_entity.dart';
import 'package:zkp_app/app/utils/failure.dart';

abstract interface class AppRepository {
  Future<Either<Failure, UserEntity>> register({
    required String username,
    required double latitude,
    required double longitude,
  });
}
