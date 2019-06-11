import 'package:equatable/equatable.dart';
import 'package:tdd_practice/core/usercase/usecase.dart';
import 'package:tdd_practice/core/utils/typedef.dart';
import 'package:tdd_practice/src/authentication/domain/repositories/authentication_repository.dart';

class LoginUser extends UsecaseWithParam<void, LoginUserParams> {
  const LoginUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultVoid call(LoginUserParams params) async => _repository.createUser(
        email: params.email,
        password: params.password,
      );
}

class LoginUserParams extends Equatable {
  final String email;
  final String password;

  const LoginUserParams({
    required this.email,
    required this.password,
  });

  const LoginUserParams.empty()
      : this(
          email: '_empty.email',
          password: '_empty.password',
        );

  @override
  List<Object?> get props => [];
}
