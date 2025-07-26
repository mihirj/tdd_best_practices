import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tdd_practice/core/errors/exceptions.dart';
import 'package:tdd_practice/core/utils/typedef.dart';
import 'package:tdd_practice/src/authentication/data/models/user_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> loginUser({
    required String email,
    required String password,
  });

  Future<List<UserModel>> getUsers();
}

const kLoginUserEndpoint = '/auth/provider/login';
const kCreateUserEndpoint = '/test-api/users';
const kGetUserEndpoint = '/test-api/users';

class AuthRemoteDataSrcImpl implements AuthenticationRemoteDataSource {
  const AuthRemoteDataSrcImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      final response = await _dio.post(kLoginUserEndpoint,
          data: jsonEncode({
            'email': email,
            'password': password,
          }),
          options: Options(headers: {'Content-Type': 'application/json'}));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
          message: response.data,
          statusCode: response.statusCode ?? 500,
        );
      }
    } on APIException {
      rethrow;
    } on DioException catch (e) {
      throw APIException(
        message: e.response?.data?["message"] ?? 'Unknown error occurred',
        statusCode: e.response?.statusCode ?? 505,
      );
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _dio.get(
        kGetUserEndpoint,
      );

      if (response.statusCode != 200) {
        throw APIException(
          message: response.data,
          statusCode: response.statusCode ?? 500,
        );
      }

      return List<DataMap>.from(jsonDecode(response.data) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}
