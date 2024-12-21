import 'package:tdd_practice/core/utils/typedef.dart';
import 'package:tdd_practice/src/authentication/domain/entities/user.dart';
import 'package:tdd_practice/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  ResultFuture<List<User>> getUsers() {
    // TODO: implement getUsers
    throw UnimplementedError();
  }
}
