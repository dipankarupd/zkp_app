import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/data/datasource/remote_source.dart';
import 'package:zkp_app/app/data/model/register_user_model.dart';
import 'package:zkp_app/app/data/model/result_model.dart';
import 'package:zkp_app/app/domain/entity/register_user_entity.dart';
import 'package:zkp_app/app/domain/entity/result_entity.dart';
import 'package:zkp_app/app/domain/repository/app_repository.dart';
import 'package:zkp_app/app/utils/failure.dart';

class AppRepositoryImpl implements AppRepository {
  final RemoteDataSource source;

  AppRepositoryImpl({required this.source});

  @override
  Future<Either<Failure, UserEntity>> register(
      {required String username,
      required double latitude,
      required double longitude}) async {
    try {
      UserModel user = await source.register(
        username: username,
        latitude: latitude,
        longitude: longitude,
      );

      return right(user);
    } catch (e) {
      return left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String token,
  }) async {
    try {
      UserModel user = await source.login(token: token);
      return right(user);
    } catch (e) {
      return left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ResultEntity>> verifyResult(
      {required int distance}) async {
    try {
      ResultModel res = await source.verify(distance: distance);
      return right(res);
    } catch (e) {
      return left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser({
    required String token,
    required String date,
    required bool isPresent,
  }) async {
    try {
      UserModel user = await source.updateContents(
        token: token,
        date: date,
        isPresent: isPresent,
      );

      return right(user);
    } catch (e) {
      return left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }
}
