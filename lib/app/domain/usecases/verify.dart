import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/domain/entity/result_entity.dart';
import 'package:zkp_app/app/domain/repository/app_repository.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class Verify implements Usecase<ResultEntity, VerifyParams> {
  final AppRepository repository;

  Verify({
    required this.repository,
  });

  @override
  Future<Either<Failure, ResultEntity>> call(VerifyParams params) async {
    return await repository.verifyResult(distance: params.distance);
  }
}

class VerifyParams {
  final int distance;

  VerifyParams({required this.distance});
}
