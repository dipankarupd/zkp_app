import 'package:fpdart/fpdart.dart';
import 'package:zkp_app/app/features/student/auth/domain/entity/student_entity.dart';
import 'package:zkp_app/app/utils/failure.dart';

abstract interface class UserRepo {
  Future<Either<Failure, StudentEntity>> register({
    required String username,
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, StudentEntity>> login({
    required String token,
  });
}
