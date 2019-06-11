import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_practice/core/errors/exceptions.dart';
import 'package:tdd_practice/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_practice/src/authentication/data/models/user_model.dart';

class MockClient extends Mock implements Dio {}

void main() {
  late Dio client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthRemoteDataSrcImpl(client);
    registerFallbackValue(Uri());
  });

  group(
    'createUser',
    () {
      test(
        'should complete successfully when the status code is 200 or 201',
        () async {
          // Arrange
          when(
            () => client.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: kCreateUserEndpoint),
              data: 'User created successfully',
              statusCode: 201,
            ),
          );

          // Act & Assert
          expect(
            remoteDataSource.loginUser(
              createdAt: 'createdAt',
              name: 'name',
              avatar: 'avatar',
            ),
            completes,
          );

          verify(
            () => client.post(
              kCreateUserEndpoint,
              data: jsonEncode({
                'createdAt': 'createdAt',
                'name': 'name',
                'avatar': 'avatar',
              }),
              options: any(named: 'options'),
            ),
          ).called(1);

          verifyNoMoreInteractions(client);
        },
      );

      test(
        'should throw [APIException] when the status code is not 200 or 201',
        () async {
          // Arrange
          when(
            () => client.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: kCreateUserEndpoint),
              data: 'Invalid email address',
              statusCode: 400,
            ),
          );

          // Act & Assert
          expect(
            () => remoteDataSource.loginUser(
              createdAt: 'createdAt',
              name: 'name',
              avatar: 'avatar',
            ),
            throwsA(
              const APIException(
                  message: 'Invalid email address', statusCode: 400),
            ),
          );

          verify(
            () => client.post(
              kCreateUserEndpoint,
              data: jsonEncode({
                'createdAt': 'createdAt',
                'name': 'name',
                'avatar': 'avatar',
              }),
              options: any(named: 'options'),
            ),
          ).called(1);

          verifyNoMoreInteractions(client);
        },
      );
    },


    
  );

  group(
    'getUsers',
    () {
      
      const tUsers = [UserModel.empty()];
      test(
        'should return [List<User>] when the status code is 200',
        () async {
          // Arrange
          when(
            () => client.get(
              any(),
              options: any(named: 'options'),
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: kGetUserEndpoint),
              data: jsonEncode([tUsers.first.toMap()]),
              statusCode: 200,
            ),
          );

          // Act
          final result = await remoteDataSource.getUsers();

          // Assert
          expect(result, equals(tUsers));

          verify(
            () => client.get(
              kGetUserEndpoint,
              options: any(named: 'options'),
            ),
          ).called(1);
          verifyNoMoreInteractions(client);
        },
      );

      test(
        'should throw [APIException] when the status code is not 200',
        () async {
          // Arrange
          const tMessage = 'Server down, server down, ohhh my God!!!';
          when(
            () => client.get(
              any(),
              options: any(named: 'options'),
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: kGetUserEndpoint),
              data: tMessage,
              statusCode: 500,
            ),
          );

          // Act & Assert
          expect(
            () => remoteDataSource.getUsers(),
            throwsA(
              const APIException(message: tMessage, statusCode: 500),
            ),
          );

          verify(
            () => client.get(
              kGetUserEndpoint,
              options: any(named: 'options'),
            ),
          ).called(1);
          verifyNoMoreInteractions(client);
        },
      );
    },
  );
}
