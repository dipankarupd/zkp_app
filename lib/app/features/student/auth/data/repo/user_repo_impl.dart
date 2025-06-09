import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/features/student/auth/data/models/student_model.dart';
import 'package:zkp_app/app/features/student/auth/data/source/user_data_source.dart';
import 'package:zkp_app/app/features/student/auth/domain/entity/student_entity.dart';
import 'package:zkp_app/app/features/student/auth/domain/repo/user_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';

class UserRepoImpl implements UserRepo {
  final UserDataSource source;

  UserRepoImpl({
    required this.source,
  });

  @override
  Future<Either<Failure, StudentEntity>> register({
    required String username,
    required double latitude,
    required double longitude,
  }) async {
    try {
      StudentModel user = await source.register(
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
  Future<Either<Failure, StudentEntity>> login({required String token}) async {
    try {
      StudentModel user = await source.login(token: token);
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
