import 'package:fpdart/fpdart.dart';
import 'package:zkp_app/app/domain/entity/register_user_entity.dart';
import 'package:zkp_app/app/domain/entity/result_entity.dart';
import 'package:zkp_app/app/utils/failure.dart';

abstract interface class AppRepository {
  Future<Either<Failure, UserEntity>> register({
    required String username,
    required double latitude,
    required double longitude,
  });
  Future<Either<Failure, UserEntity>> login({
    required String token,
  });
  Future<Either<Failure, ResultEntity>> verifyResult({
    required int distance,
  });
  Future<Either<Failure, UserEntity>> updateUser({
    required String token,
    required String date,
    required bool isPresent,
  });
}
