import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_practice/core/errors/failure.dart';
import 'package:tdd_practice/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_practice/src/authentication/domain/usecases/login_user.dart';
import 'package:tdd_practice/src/authentication/presentation/cubit/authentication_cubit.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements LoginUser {}

void main() {
  late GetUsers getUsers;
  late LoginUser createUser;
  late AuthenticationCubit cubit;

  const tCreateUserParams = LoginUserParams.empty();

  const tAPIFailure = APIFailure(message: 'message', statusCode: 400);

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => cubit.close());

  test('Initial state should be [AuthenticationInitial', () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group(
    'createUser',
    () {
      blocTest<AuthenticationCubit, AuthenticationCState>(
        'should emit [CreatingUser, UserCreated] when successful',
        build: () {
          when(() => createUser(any())).thenAnswer(
            (_) async => const Right(null),
          );
          return cubit;
        },
        act: (cubit) => cubit.createUser(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.firstName,
          avatar: tCreateUserParams.profileImage,
        ),
        expect: () => const [
          CreatingUser(),
          UserCreated(),
        ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        },
      );
      blocTest<AuthenticationCubit, AuthenticationCState>(
        'should emit [CreatingUser,AuthenticationError] when unsuccessful',
        build: () {
          when(() => createUser(any())).thenAnswer(
            (_) async => const Left(tAPIFailure),
          );
          return cubit;
        },
        act: (cubit) {
          cubit.createUser(
            createdAt: tCreateUserParams.createdAt,
            name: tCreateUserParams.firstName,
            avatar: tCreateUserParams.profileImage,
          );
        },
        expect: () => [
          const CreatingUser(),
          AuthenticationError(tAPIFailure.errorMessage)
        ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        },
      );
    },
  );
  group(
    'getUsers',
    () {
      blocTest<AuthenticationCubit, AuthenticationCState>(
        'should emit [GettingUsers, UsersLoaded] when successful',
        build: () {
          when(() => getUsers()).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) => cubit.getUsers(),
        expect: () => const [GettingUsers(), UsersLoaded([])],
        verify: (_) {
          verify(() => getUsers()).called(1);
          verifyNoMoreInteractions(getUsers);
        },
      );
      blocTest<AuthenticationCubit, AuthenticationCState>(
        'should emit [GettingUsers, AuthenticationError] when unsuccessful',
        build: () {
          when(() => getUsers())
              .thenAnswer((_) async => const Left(tAPIFailure));
          return cubit;
        },
        act: (cubit) => cubit.getUsers(),
        expect: () => [
          const GettingUsers(),
          AuthenticationError(tAPIFailure.errorMessage),
        ],
        verify: (_) {
          verify(() => getUsers()).called(1);
          verifyNoMoreInteractions(getUsers);
        },
      );
    },
  );
}
