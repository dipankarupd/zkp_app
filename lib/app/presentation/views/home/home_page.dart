import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/domain/entity/register_user_entity.dart';
import 'package:zkp_app/app/presentation/bloc/home/bloc/home_bloc.dart';
import 'package:zkp_app/old/widgets/verification_dialog.dart';

class HomePageNew extends StatelessWidget {
  const HomePageNew({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the user from route arguments
    final user = ModalRoute.of(context)?.settings.arguments as UserEntity?;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('Attendance'),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        // Changed BlocListener to BlocConsumer to rebuild UI when state changes
        listener: (context, state) {
          if (state is AttendanceLoadingState) {
            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Verifying location...'),
                    ],
                  ),
                );
              },
            );
          } else if (state is AttendanceSuccessState) {
            // Close loading dialog
            Navigator.of(context).pop();

            // Show verification dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return VerificationDialog2(
                  isSuccess: state.isVerified,
                  // Add onClosed callback to handle dialog dismissal
                  onClosed: () {
                    // Reload the current page with updated user data
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePageNew(),
                        settings: RouteSettings(arguments: state.user),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is AttendanceFailureState) {
            // Close loading dialog if open
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }

            // Show error dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content:
                      Text('Something went extremely wrong. Try again later!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Reload the current page with existing user data
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePageNew(),
                            settings: RouteSettings(arguments: user),
                          ),
                        );
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          }
        },
        // The builder will rebuild the UI based on the state
        builder: (context, state) {
          // Determine which user data to use
          final displayUser =
              state is AttendanceSuccessState ? state.user : user;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/man.jpg'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      displayUser!.name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Text(
                            'Last checked in at: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            displayUser.lastChecked != null
                                ? displayUser.lastChecked!.toIso8601String()
                                : 'Not checked in',
                            style: TextStyle(
                              color: displayUser.lastChecked != null
                                  ? Colors.brown[500]
                                  : Colors.red, // Red if null
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Attendance History',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Present: ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              displayUser.presentCount.toString(),
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Absent: ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              displayUser.absentCount.toString(),
                              style: TextStyle(
                                color: Colors.red[800],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    InkWell(
                      onTap: () {
                        if (displayUser != null) {
                          context.read<HomeBloc>().add(
                                MarkAttendanceEvent(
                                  token: displayUser.token.toString(),
                                  latitude: displayUser.location.latitude,
                                  longitude: displayUser.location.longitude,
                                ),
                              );
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Mark Attendance',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
