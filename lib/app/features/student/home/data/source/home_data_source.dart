import 'package:dio/dio.dart';
import 'package:zkp_app/app/config/constants/app_constants.dart';
import 'package:zkp_app/app/features/student/home/data/model/classroom_model.dart';
import 'package:zkp_app/app/utils/exceptions.dart';
import 'package:zkp_app/app/utils/logger_util.dart';

abstract interface class StudentHomeDataSource {
  Future<List<ClassroomModel>> getClassrooms();

  Future<List<ClassroomModel>> getClassroomsForStudent({
    required String token,
  });

  Future<String> joinClassroom({
    required String classroomId,
    required String token,
  });
}

class StudentHomeDataSourceImpl implements StudentHomeDataSource {
  final Dio dio;

  StudentHomeDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<ClassroomModel>> getClassrooms() async {
    const endpoint = '${AppConstants.APP_URL}/api/classrooms';

    LoggerUtils.logRequest('GET_CLASSROOMS', endpoint, null);

    try {
      final res = await dio.get(endpoint);

      LoggerUtils.logSuccess('GET_CLASSROOMS', res.statusCode, res.data);

      final List<dynamic> data = res.data['data'];
      final classrooms = data
          .map((json) => ClassroomModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return classrooms;
    } catch (e) {
      LoggerUtils.logError('GET_CLASSROOMS', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }

  @override
  Future<List<ClassroomModel>> getClassroomsForStudent(
      {required String token}) async {
    final endpoint = '${AppConstants.APP_URL}/api/student/${token}/classrooms';

    LoggerUtils.logRequest('GET_CLASSROOMS', endpoint, null);

    try {
      final res = await dio.get(endpoint);

      LoggerUtils.logSuccess(
          'GET_CLASSROOMS_OF_STUDENT', res.statusCode, res.data);

      final List<dynamic> data = res.data['data'];
      final classrooms = data
          .map((json) => ClassroomModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return classrooms;
    } catch (e) {
      LoggerUtils.logError('GET_CLASSROOMS_OF_STUDENT', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }

  @override
  Future<String> joinClassroom({
    required String classroomId,
    required String token,
  }) async {
    final endpoint = '${AppConstants.APP_URL}/api/classrooms/$classroomId/join';
    final intToken = int.tryParse(token);

    LoggerUtils.logRequest('JOIN_CLASSROOM', endpoint, {'token': token});

    try {
      final res = await dio.post(
        endpoint,
        data: {'token': intToken},
      );

      LoggerUtils.logSuccess('JOIN_CLASSROOM', res.statusCode, res.data);

      return res.data['message'] as String;
    } catch (e) {
      LoggerUtils.logError('JOIN_CLASSROOM', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }
}
