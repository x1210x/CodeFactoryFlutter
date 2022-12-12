import 'package:codefactory_flutter/common/model/login_response.dart';
import 'package:codefactory_flutter/common/model/token_response.dart';
import 'package:codefactory_flutter/common/utils/data_utils.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  AuthRepository({
    required this.dio,
    required this.baseUrl,
  });

  final Dio dio;
  final String baseUrl;

  Future<LoginResponse> login({
    required String username,
    required String password
  }) async {
    final serialized = DataUtils.plainToBase64('$username:$password');
    final resp = await dio.post(
      '$baseUrl/login',
      options: Options(
        headers: {
          'authorization': 'Basic $serialized',
        }
      )
    );
    return LoginResponse.fromJson(resp.data);
  }

  Future<TokenResponse> token() async {
    final resp = await dio.post(
        '$baseUrl/token',
        options: Options(
            headers: {
              'refreshToken': 'true',
            }
        )
    );
    return TokenResponse.fromJson(resp.data);
  }
}