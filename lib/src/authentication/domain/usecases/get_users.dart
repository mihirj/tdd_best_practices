import 'package:tdd_practice/core/usercase/usecase.dart';
import 'package:tdd_practice/core/utils/typedef.dart';
import 'package:tdd_practice/src/authentication/domain/entities/user.dart';
import 'package:tdd_practice/src/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends UsecaseWithoutParams<List<User>> {
  const GetUsers(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}
