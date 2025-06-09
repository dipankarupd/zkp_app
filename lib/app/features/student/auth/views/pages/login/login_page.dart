import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/config/routes/app_routes.dart';
import 'package:zkp_app/app/features/student/auth/views/bloc/login/bloc/login_bloc.dart';
import 'package:zkp_app/app/features/student/auth/views/widget/circle_button.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _tokenController = TextEditingController();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.studentHomePage,
              arguments: state.user,
            );
          } else if (state is LoginFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Something went Wrong. Try again'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 100,
              left: 10,
              right: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Remote',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: height * 0.065,
                  ),
                ),
                Text(
                  'Attendance',
                  style: TextStyle(
                    color: Colors.green[200],
                    fontSize: height * 0.078,
                  ),
                ),
                Text(
                  'Enter your 6 digit token to login.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Text(
                  'Enter your token',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: .78,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextField(
                  controller: _tokenController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: "Token",
                    hintStyle: TextStyle(
                      letterSpacing: .84,
                      fontSize: 12,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is LoginLoadingState) {
                          return const CircularProgressIndicator(
                            color: Colors.green,
                          );
                        }
                        return CircleButton(
                          onPressed: () {
                            if (_tokenController.text.isNotEmpty) {
                              context.read<LoginBloc>().add(
                                    LoginSubmittedEvent(
                                      token: _tokenController.text,
                                    ),
                                  );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your token'),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Do not have a token? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.registrationPage,
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                        AppRoutes.adminLoginPage,
                      );
                    },
                    child: const Text(
                      'Admin Portal',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
