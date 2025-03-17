import 'package:fpdart/fpdart.dart';
import 'package:zkp_app/app/utils/failure.dart';

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
