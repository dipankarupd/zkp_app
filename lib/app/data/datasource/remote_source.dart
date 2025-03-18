import 'package:dio/dio.dart';
import 'package:zkp_app/app/config/constants/app_constants.dart';

import 'package:zkp_app/app/data/model/register_user_model.dart';
import 'package:zkp_app/app/data/model/result_model.dart';
import 'package:zkp_app/app/utils/exceptions.dart';
import 'package:zkp_app/app/utils/logger_util.dart';

abstract interface class RemoteDataSource {
  Future<UserModel> register({
    required String username,
    required double latitude,
    required double longitude,
  });

  Future<UserModel> login({
    required String token,
  });

  Future<ResultModel> verify({
    required int distance,
  });

  Future<UserModel> updateContents({
    required String token,
    required String date,
    required bool isPresent,
  });
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<UserModel> register({
    required String username,
    required double latitude,
    required double longitude,
  }) async {
    final endpoint = '${AppConstants.APP_URL}/register';
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

      final user = UserModel.fromJson(res.data as Map<String, dynamic>);
      return user;
    } catch (e) {
      LoggerUtils.logError('REGISTER', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }

  @override
  Future<UserModel> login({required String token}) async {
    final endpoint = '${AppConstants.APP_URL}/user/$token';

    LoggerUtils.logRequest('LOGIN', endpoint, token);

    try {
      final res = await dio.get(endpoint);

      LoggerUtils.logSuccess('LOGIN', res.statusCode, res.data);

      final user = UserModel.fromJson(res.data as Map<String, dynamic>);
      return user;
    } catch (e) {
      LoggerUtils.logError('LOGIN', e);
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

  @override
  Future<UserModel> updateContents({
    required String token,
    required String date,
    required bool isPresent,
  }) async {
    final endpoint = '${AppConstants.APP_URL}/students/$token/attendance';

    print('Date: $date');
    final requestData = {
      "last_checked": date,
      "is_present": isPresent,
    };

    LoggerUtils.logRequest('UPDATE_CONTENTS', endpoint, requestData);

    try {
      final res = await dio.put(
        endpoint,
        data: requestData,
      );

      LoggerUtils.logSuccess('UPDATE_CONTENTS', res.statusCode, res.data);

      final data = res.data as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } catch (e) {
      LoggerUtils.logError('UPDATE_CONTENTS', e);
      throw AppException(message: LoggerUtils.getErrorMessage(e));
    }
  }
}
