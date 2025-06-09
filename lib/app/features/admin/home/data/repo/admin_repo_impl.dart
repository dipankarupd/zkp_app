import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/features/admin/home/data/model/classroom_detail_model.dart';
import 'package:zkp_app/app/features/admin/home/data/source/admin_source.dart';
import 'package:zkp_app/app/features/admin/home/domain/entity/classroom_detail_entity.dart';
import 'package:zkp_app/app/features/admin/home/domain/repo/admin_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';

class AdminRepoImpl implements AdminRepo {
  final AdminSource source;

  AdminRepoImpl({required this.source});
  @override
  Future<Either<Failure, String>> createClassroom({
    required String name,
    required String description,
    required String teacherName,
  }) async {
    try {
      final String res = await source.createClassroom(
          name: name, description: description, teacherName: teacherName);
      return right(res);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClassroomDetailEntity>> getClassroomDetail({
    required String classroomId,
  }) async {
    try {
      final ClassroomDetailModel res =
          await source.getClassroomDetail(classroomId: classroomId);
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
  Future<Either<Failure, String>> createClass({
    required DateTime startTime,
    required DateTime endTime,
    required String meetLink,
    required String classroomId,
  }) async {
    try {
      final String res = await source.createClass(
        startDate: startTime,
        endDate: endTime,
        meetLink: meetLink,
        classroomId: classroomId,
      );

      return right(res);
    } catch (e) {
      return left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }
}
