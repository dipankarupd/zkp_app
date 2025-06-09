import 'package:dio/dio.dart';
import 'package:zkp_app/app/config/constants/app_constants.dart';
import 'package:zkp_app/app/features/admin/home/data/model/classroom_detail_model.dart';
import 'package:zkp_app/app/utils/exceptions.dart';
import 'package:zkp_app/app/utils/logger_util.dart';

abstract interface class AdminSource {
  Future<String> createClassroom({
    required String name,
    required String description,
    required String teacherName,
  });

  Future<ClassroomDetailModel> getClassroomDetail({
    required String classroomId,
  });

  Future<String> createClass({
    required DateTime startDate,
    required DateTime endDate,
    required String meetLink,
    required String classroomId,
  });
}

class AdminSourceImpl implements AdminSource {
  final Dio dio;

  AdminSourceImpl({required this.dio});

  @override
  Future<String> createClassroom({
    required String name,
    required String description,
    required String teacherName,
  }) async {
    const endpoint = '${AppConstants.APP_URL}/api/classrooms';

    final body = {
      "name": name,
      "description": description,
      "teacher_name": teacherName,
    };

    LoggerUtils.logRequest('CREATE_CLASSROOM', endpoint, body);

    try {
      final res = await dio.post(endpoint, data: body);

      LoggerUtils.logSuccess('CREATE_CLASSROOM', res.statusCode, res.data);

      return res.data['message'] as String;
    } catch (e) {
      LoggerUtils.logError('CREATE_CLASSROOM', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }

  @override
  Future<ClassroomDetailModel> getClassroomDetail({
    required String classroomId,
  }) async {
    final endpoint = '${AppConstants.APP_URL}/api/classrooms/$classroomId';

    LoggerUtils.logRequest('GET_CLASSROOM_DETAIL', endpoint, classroomId);

    try {
      final res = await dio.get(endpoint);

      LoggerUtils.logSuccess('GET_CLASSROOM_DETAIL', res.statusCode, res.data);

      final data = res.data['data'] as Map<String, dynamic>;

      return ClassroomDetailModel.fromJson(data);
    } catch (e) {
      LoggerUtils.logError('GET_CLASSROOM_DETAIL', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }

  @override
  Future<String> createClass({
    required DateTime startDate,
    required DateTime endDate,
    required String meetLink,
    required String classroomId,
  }) async {
    final endpoint =
        '${AppConstants.APP_URL}/api/classrooms/$classroomId/classes';

    final body = {
      "start_time": startDate.toUtc().toIso8601String(),
      "end_time": endDate.toUtc().toIso8601String(),
      "link": meetLink,
    };

    LoggerUtils.logRequest('CREATE_CLASS', endpoint, body);

    try {
      final res = await dio.post(endpoint, data: body);

      LoggerUtils.logSuccess('CREATE_CLASS', res.statusCode, res.data);

      return res.data['message'] as String;
    } catch (e) {
      LoggerUtils.logError('CREATE_CLASS', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }
}
