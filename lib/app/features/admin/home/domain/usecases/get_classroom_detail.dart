import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/features/admin/home/domain/entity/classroom_detail_entity.dart';
import 'package:zkp_app/app/features/admin/home/domain/repo/admin_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class GetClassroomDetailAdmin
    implements Usecase<ClassroomDetailEntity, GetClassroomDetailParams> {
  final AdminRepo repo;

  GetClassroomDetailAdmin({required this.repo});
  @override
  Future<Either<Failure, ClassroomDetailEntity>> call(
      GetClassroomDetailParams params) async {
    return await repo.getClassroomDetail(
      classroomId: params.classroomId,
    );
  }
}

class GetClassroomDetailParams {
  final String classroomId;

  GetClassroomDetailParams({required this.classroomId});
}
