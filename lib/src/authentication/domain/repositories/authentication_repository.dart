import 'package:tdd_practice/core/utils/typedef.dart';
import 'package:tdd_practice/src/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  ResultVoid createUser({
    required String email,
    required String password,
  });

  ResultFuture<List<User>> getUsers();
}
