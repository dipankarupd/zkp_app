import 'package:fpdart/src/either.dart';
import 'package:zkp_app/app/features/student/classroom/domain/repo/classroom_repo.dart';
import 'package:zkp_app/app/utils/failure.dart';
import 'package:zkp_app/app/utils/use_case.dart';

class MarkAttendance implements Usecase<String, MarkAttendanceUsecase> {
  final StudentClassroomRepo repo;

  MarkAttendance({required this.repo});
  @override
  Future<Either<Failure, String>> call(MarkAttendanceUsecase params) async {
    return await repo.markAttendance(
        classId: params.classId,
        studentToken: params.studentToken,
        isPresent: params.isPresent);
  }
}

class MarkAttendanceUsecase {
  final String classId;
  final String studentToken;
  final bool isPresent;

  MarkAttendanceUsecase(
      {required this.classId,
      required this.studentToken,
      required this.isPresent});
}
