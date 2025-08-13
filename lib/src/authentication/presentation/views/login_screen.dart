import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_practice/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:tdd_practice/src/authentication/presentation/widgets/add_user_dialog.dart';
import 'package:tdd_practice/src/authentication/presentation/widgets/loading_column.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();

  void getUsers() {
    context.read<AuthenticationBloc>().add(const GetUserEvent());
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is UserCreated) {
          getUsers();
        }
      },
      builder: (context, state) {
        final users = state is UsersLoaded ? state.users : [];
        return Scaffold(
          body: SafeArea(
              child: state is GettingUsers
                  ? const LoadingColumn(message: 'Fetching users')
                  : state is CreatingUser
                      ? const LoadingColumn(message: 'Creating users')
                      : Center(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return ListTile(
                                leading: Image.network(
                                  user.avatar,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error_outline),
                                ),
                                title: Text(user.name),
                                subtitle: Text(user.createdAt.substring(10)),
                              );
                            },
                          ),
                        )),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AddUserDialog(
                  nameController: nameController,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add User'),
          ),
        );
      },
    );
  }
}
