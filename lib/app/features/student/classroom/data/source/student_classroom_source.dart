import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zkp_app/app/config/constants/app_constants.dart';
import 'package:zkp_app/app/features/student/classroom/data/model/class_model.dart';
import 'package:zkp_app/app/features/student/classroom/data/model/get_classroom_detail_model.dart';
import 'package:zkp_app/app/features/student/classroom/data/model/result_model.dart';
import 'package:zkp_app/app/utils/exceptions.dart';
import 'package:zkp_app/app/utils/logger_util.dart';

abstract interface class StudentClassroomSource {
  Future<StudentClassroomDetailModel> getClassroomDetail({
    required String token,
    required String classroomId,
  });

  Future<ClassModel> getUpcomingClass({
    required String classroomId,
  });

  Future<String> markAttendance({
    required String classId,
    required String studentToken,
    required bool isPresent,
  });
  Future<ResultModel> verify({
    required int distance,
  });
}

class StudentClassroomSourceImpl implements StudentClassroomSource {
  final Dio dio;

  StudentClassroomSourceImpl({required this.dio});

  @override
  Future<StudentClassroomDetailModel> getClassroomDetail({
    required String token,
    required String classroomId,
  }) async {
    final endpoint =
        '${AppConstants.APP_URL}/api/students/$token/classrooms/$classroomId/progress';

    LoggerUtils.logRequest('GET_CLASSROOM_DETAIL', endpoint, null);

    try {
      final res = await dio.get(endpoint);

      LoggerUtils.logSuccess('GET_CLASSROOM_DETAIL', res.statusCode, res.data);

      final data = res.data['data'] as Map<String, dynamic>;

      return StudentClassroomDetailModel.fromMap(data);
    } catch (e) {
      LoggerUtils.logError('GET_CLASSROOM_DETAIL', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }

  @override
  Future<ClassModel> getUpcomingClass({required String classroomId}) async {
    final endpoint =
        '${AppConstants.APP_URL}/api/classrooms/$classroomId/upcomingclasses';

    LoggerUtils.logRequest('GET_UPCOMING_CLASS', endpoint, null);

    try {
      final res = await dio.get(endpoint);

      LoggerUtils.logSuccess('GET_UPCOMING_CLASS', res.statusCode, res.data);

      final data = res.data['data'] as Map<String, dynamic>;

      return ClassModel.fromMap(data);
    } catch (e) {
      LoggerUtils.logError('GET_UPCOMING_CLASS', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }

  @override
  Future<String> markAttendance({
    required String classId,
    required String studentToken,
    required bool isPresent,
  }) async {
    final endpoint =
        '${AppConstants.APP_URL}/api/student/$studentToken/classes/$classId/attendance';

    final checkedInTime =
        DateTime.now().toUtc().toIso8601String(); // 🕐 UTC is safer

    final payload = {
      'checked_in_time': checkedInTime,
      'is_present': isPresent,
    };

    LoggerUtils.logRequest('MARK_ATTENDANCE', endpoint, payload);

    try {
      final res = await dio.post(
        endpoint,
        data: jsonEncode(payload),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      LoggerUtils.logSuccess('MARK_ATTENDANCE', res.statusCode, res.data);

      final data = res.data['data'];
      if (data != null &&
          data is Map<String, dynamic> &&
          data['meet_link'] != null) {
        return data['meet_link'] as String;
      }

      return "Attendance marked successfully.";
    } catch (e) {
      LoggerUtils.logError('MARK_ATTENDANCE', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }

  @override
  Future<ResultModel> verify({required int distance}) async {
    final endpoint = AppConstants.BACKEND_URL;
    final requestData = {"distance": distance};

    LoggerUtils.logRequest('VERIFY', endpoint, requestData);

    try {
      final res = await dio.post(
        endpoint,
        data: requestData,
      );

      LoggerUtils.logSuccess('VERIFY', res.statusCode, res.data);

      final data = res.data as Map<String, dynamic>;
      return ResultModel.fromMap(data);
    } catch (e) {
      LoggerUtils.logError('VERIFY', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }
}
