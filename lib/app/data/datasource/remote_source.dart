// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:zkp_app/app/config/constants/app_constants.dart';

import 'package:zkp_app/app/data/model/register_user_model.dart';
import 'package:zkp_app/app/utils/exceptions.dart';

abstract interface class RemoteDataSource {
  Future<UserModel> register({
    required String username,
    required double latitude,
    required double longitude,
  });

  Future<UserModel> login({
    required String token,
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
    try {
      print('$username $latitude');
      print('${AppConstants.APP_URL}/register');
      final res = await dio.post(
        '${AppConstants.APP_URL}/register',
        data: {
          'name': username,
          'latitude': latitude,
          'longitude': longitude,
        },
      );
      print('res: $res');
      final user = UserModel.fromJson(res.data as Map<String, dynamic>);
      return user;
    } catch (e) {
      print(e.toString());
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<UserModel> login({required String token}) async {
    try {
      final res = await dio.get('${AppConstants.APP_URL}/user/$token');
      final user = UserModel.fromJson(res.data as Map<String, dynamic>);
      return user;
    } catch (e) {
      print(e.toString());
      throw AppException(message: e.toString());
    }
  }
}
