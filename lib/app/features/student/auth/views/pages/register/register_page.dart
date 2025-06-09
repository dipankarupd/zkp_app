import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/config/routes/app_routes.dart';
import 'package:zkp_app/app/features/student/auth/views/bloc/registration/bloc/bloc_bloc.dart';
import 'package:zkp_app/app/features/student/auth/views/widget/circle_button.dart';

class RegistrationPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.status == RegistrationStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: height * 0.1,
              left: 10,
              right: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome!!!',
                  style: TextStyle(
                    color: Colors.green[400],
                    fontSize: height * 0.077,
                  ),
                ),
                Text(
                  'Please Register to start the remote attendance.',
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
                  'Enter your username',
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
                  controller: _usernameController,
                  onChanged: (value) {
                    context.read<RegistrationBloc>().add(
                          UserNameChangedEvent(username: value),
                        );
                  },
                  decoration: InputDecoration(
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
                    hintText: "Username",
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
                Text(
                  'The system wants you to choose a location you prefer to attend from. Proceed to choose ...',
                  style: TextStyle(
                    color: Colors.grey[800],
                    letterSpacing: .7,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: CircleButton(
                      onPressed: () {
                        final username = _usernameController.text.trim();
                        if (username.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Username is required')),
                          );
                          return;
                        }

                        Navigator.of(context).pushNamed(
                          AppRoutes.registerMapPage,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already Registered? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.initial,
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
