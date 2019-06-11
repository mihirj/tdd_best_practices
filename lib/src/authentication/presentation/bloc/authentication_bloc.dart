import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_practice/src/authentication/domain/entities/user.dart';
import 'package:tdd_practice/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_practice/src/authentication/domain/usecases/login_user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required LoginUser loginUser,
    required GetUsers getUsers,
  })  : _loginUser = loginUser,
        _getUsers = getUsers,
        super(const AuthenticationInitial()) {
    on<LoginUserEvent>(_loginUserHandler);
    on<GetUserEvent>(_getUsersHandler);
  }

  final LoginUser _loginUser;
  final GetUsers _getUsers;

  Future<void> _loginUserHandler(
    LoginUserEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const LogginUser());

    final result = await _loginUser(
      LoginUserParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (_) => emit(const UserLoggedIn()),
    );
  }

  Future<void> _getUsersHandler(
      GetUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const GettingUsers());

    final result = await _getUsers();

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (users) => emit(UsersLoaded(users)),
    );
  }
}
