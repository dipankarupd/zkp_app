import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/features/student/classroom/data/model/class_model.dart';
import 'package:zkp_app/app/features/student/classroom/data/model/get_classroom_detail_model.dart';
import 'package:zkp_app/app/features/student/classroom/data/model/result_model.dart';
import 'package:zkp_app/app/features/student/classroom/data/source/student_classroom_source.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/classs_entity.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/get_classroom_detail.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/result_entity.dart';
import 'package:zkp_app/app/features/student/classroom/domain/repo/classroom_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';

class StudentClassroomRepoImpl implements StudentClassroomRepo {
  final StudentClassroomSource source;

  StudentClassroomRepoImpl({
    required this.source,
  });

  @override
  Future<Either<Failure, StudentClassroomDetailEntity>> getMyDetail({
    required String token,
    required String classroomId,
  }) async {
    try {
      StudentClassroomDetailModel resp = await source.getClassroomDetail(
        classroomId: classroomId,
        token: token,
      );
      return right(resp);
    } catch (e) {
      return left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ClassEntity>> getUpcomingClass({
    required String classroomId,
  }) async {
    try {
      ClassModel resp = await source.getUpcomingClass(
        classroomId: classroomId,
      );
      return right(resp);
    } catch (e) {
      return left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> markAttendance({
    required String classId,
    required String studentToken,
    required bool isPresent,
  }) async {
    try {
      String resp = await source.markAttendance(
        classId: classId,
        studentToken: studentToken,
        isPresent: isPresent,
      );
      return right(resp);
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
}
