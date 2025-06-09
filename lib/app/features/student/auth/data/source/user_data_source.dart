import 'package:dio/dio.dart';
import 'package:zkp_app/app/config/constants/app_constants.dart';
import 'package:zkp_app/app/features/student/auth/data/models/student_model.dart';
import 'package:zkp_app/app/utils/exceptions.dart';
import 'package:zkp_app/app/utils/logger_util.dart';

abstract interface class UserDataSource {
  Future<StudentModel> register({
    required String username,
    required double latitude,
    required double longitude,
  });

  Future<StudentModel> login({
    required String token,
  });
}

class UserDataSourceImpl implements UserDataSource {
  final Dio dio;

  UserDataSourceImpl({
    required this.dio,
  });

  @override
  Future<StudentModel> register({
    required String username,
    required double latitude,
    required double longitude,
  }) async {
    final endpoint = '${AppConstants.APP_URL}/api/student/register';
    final requestData = {
      'name': username,
      'latitude': latitude,
      'longitude': longitude,
    };

    LoggerUtils.logRequest('REGISTER', endpoint, requestData);

    try {
      final res = await dio.post(
        endpoint,
        data: requestData,
      );

      LoggerUtils.logSuccess('REGISTER', res.statusCode, res.data);

      // Extract just the "data" part of the response
      final user =
          StudentModel.fromJson(res.data['data'] as Map<String, dynamic>);
      return user;
    } catch (e) {
      LoggerUtils.logError('REGISTER', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }

  @override
  Future<StudentModel> login({required String token}) async {
    final endpoint = '${AppConstants.APP_URL}/api/student/user/$token';

    LoggerUtils.logRequest('LOGIN', endpoint, token);

    try {
      final res = await dio.get(endpoint);

      LoggerUtils.logSuccess('LOGIN', res.statusCode, res.data);

      final user =
          StudentModel.fromJson(res.data['data'] as Map<String, dynamic>);

      return user;
    } catch (e) {
      LoggerUtils.logError('LOGIN', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }
}
