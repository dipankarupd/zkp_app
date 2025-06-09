import 'package:fpdart/fpdart.dart';
import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';
import 'package:zkp_app/app/features/student/home/domain/repo/home_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class GetClassrooms implements Usecase<List<ClassroomEntity>, NoParams> {
  final StudentHomeRepo repo;

  GetClassrooms({
    required this.repo,
  });

  @override
  Future<Either<Failure, List<ClassroomEntity>>> call(NoParams params) async {
    return await repo.getClassrooms();
  }
}
