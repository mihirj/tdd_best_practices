import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_practice/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:tdd_practice/src/authentication/presentation/widgets/loading_column.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // void getUsers() {
  //   context.read<AuthenticationBloc>().getUsers();
  // }

  @override
  void initState() {
    super.initState();
    // getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is UserLoggedIn) {
          // getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is GettingUsers
              ? const LoadingColumn(message: 'Fetching users')
              : state is LogginUser
                  ? const LoadingColumn(message: 'Creating users')
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<AuthenticationBloc>().add(
                                    LoginUserEvent(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                                  );
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    )
          /*Center(
                          child: ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users[index];
                              return ListTile(
                                leading: Image.network(user.avatar),
                                title: Text(user.name),
                                subtitle: Text(user.createdAt.substring(10)),
                              );
                            },
                          ),
                        )*/
          ,
/*          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AddUserDialog(
                  nameController: nameController,
                ),
              );
              // context.read<AuthenticationCubit>().createUser(
              //       createdAt: DateTime.now().toString(),
              //       name: ,
              //       avatar: avatar,
              //     );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add User'),
          ),*/
        );
      },
    );
  }
}
