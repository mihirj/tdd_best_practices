import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:tdd_practice/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_practice/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_practice/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_practice/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_practice/src/authentication/domain/usecases/login_user.dart';
import 'package:tdd_practice/src/authentication/presentation/bloc/authentication_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // App logics
    ..registerFactory(
      () => AuthenticationBloc(loginUser: sl(), getUsers: sl()),
    )

    // Use cases
    ..registerLazySingleton(() => LoginUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    // Repositories
    ..registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImplementation(sl()),
    )

    // Data Sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthRemoteDataSrcImpl(sl()),
    )

    // External Dependencies
    ..registerLazySingleton(() => Dio(BaseOptions(
            baseUrl: dotenv.env['API_BASE_URL'] ?? '',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              "Authorization": "Bearer ${dotenv.env['STATIC_API_KEY'] ?? ''}",
            })));

  await dotenv.load();
}
