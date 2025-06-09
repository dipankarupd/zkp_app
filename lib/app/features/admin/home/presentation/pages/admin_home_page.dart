// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:zkp_app/app/config/routes/app_routes.dart';
// import 'package:zkp_app/app/features/admin/home/presentation/bloc/bloc/admin_home_bloc.dart';
// import 'package:zkp_app/app/features/admin/home/presentation/widgets/admin_classroom_card.dart';

// class AdminHomePage extends StatefulWidget {
//   const AdminHomePage({super.key});

//   @override
//   State<AdminHomePage> createState() => _AdminHomePageState();
// }

// class _AdminHomePageState extends State<AdminHomePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _teacherNameController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _teacherNameController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     context.read<AdminHomeBloc>().add(
//         FetchClassroomsEvent(token: "admin")); // or real token if available
//   }

//   void _showStatusAlert(BuildContext context,
//       {required bool isSuccess, required String message}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isSuccess ? Colors.green : Colors.red,
//         duration: const Duration(seconds: 3),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }

//   void _showAddClassroomDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Create New Classroom'),
//           content: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Class Name',
//                       hintText: 'Enter class name',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter class name';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(
//                       labelText: 'Description',
//                       hintText: 'Enter class description',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter class description';
//                       }
//                       return null;
//                     },
//                     maxLines: 3,
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _teacherNameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Teacher Name',
//                       hintText: 'Enter teacher name',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter teacher name';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 // Clear form and close dialog
//                 _nameController.clear();
//                 _descriptionController.clear();
//                 _teacherNameController.clear();
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (_formKey.currentState?.validate() ?? false) {
//                   // Submit the form
//                   context.read<AdminHomeBloc>().add(
//                         CreateClassroomEvent(
//                           name: _nameController.text,
//                           description: _descriptionController.text,
//                           teacherName: _teacherNameController.text,
//                         ),
//                       );

//                   // Clear form and close dialog
//                   _nameController.clear();
//                   _descriptionController.clear();
//                   _teacherNameController.clear();
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: const Text('Create'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AdminHomeBloc, AdminHomeState>(
//       listenWhen: (previous, current) =>
//           previous.addStatus != current.addStatus &&
//           (current.addStatus == AddClassroomStatus.success ||
//               current.addStatus == AddClassroomStatus.failure),
//       listener: (context, state) {
//         if (state.addStatus == AddClassroomStatus.success) {
//           _showStatusAlert(
//             context,
//             isSuccess: true,
//             message: state.addMessage ?? 'Classroom added successfully',
//           );
//         } else if (state.addStatus == AddClassroomStatus.failure) {
//           _showStatusAlert(
//             context,
//             isSuccess: false,
//             message: state.addMessage ?? 'Failed to add classroom',
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Admin Panel'),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 _confirmLogout(context);
//               },
//               icon: const Icon(Icons.logout),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: _showAddClassroomDialog,
//           backgroundColor:
//               const Color.fromARGB(255, 101, 246, 138), // Maroon red
//           child: const Icon(Icons.add),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Classrooms',
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                       color: const Color(0xFF800000), // Maroon red
//                       fontWeight: FontWeight.bold,
//                     ),
//               ),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: BlocBuilder<AdminHomeBloc, AdminHomeState>(
//                   builder: (context, state) {
//                     switch (state.status) {
//                       case ClassroomStatus.loading:
//                         return const Center(child: CircularProgressIndicator());

//                       case ClassroomStatus.failure:
//                         return Center(
//                           child: Text(
//                             state.errorMessage ?? 'Something went wrong',
//                             style: const TextStyle(color: Colors.red),
//                           ),
//                         );

//                       case ClassroomStatus.success:
//                         if (state.classrooms.isEmpty) {
//                           return const Center(
//                               child: Text('No classrooms available.'));
//                         }

//                         return Stack(
//                           children: [
//                             GridView.builder(
//                               itemCount: state.classrooms.length,
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 childAspectRatio: 0.85,
//                                 crossAxisSpacing: 12,
//                                 mainAxisSpacing: 12,
//                               ),
//                               itemBuilder: (context, index) {
//                                 final classroom = state.classrooms[index];
//                                 return AdminClassroomCard(
//                                   classroom: classroom,
//                                 );
//                               },
//                             ),
//                             if (state.addStatus == AddClassroomStatus.loading)
//                               Container(
//                                 color: Colors.black.withOpacity(0.3),
//                                 child: const Center(
//                                   child: CircularProgressIndicator(),
//                                 ),
//                               ),
//                           ],
//                         );

//                       default:
//                         return const SizedBox.shrink();
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _confirmLogout(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Confirm Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.of(ctx).pop(); // Close dialog
//               // Show loading
//               await showDialog(
//                 barrierDismissible: false,
//                 context: context,
//                 builder: (_) => const _LogoutLoadingScreen(),
//               );
//               // After delay, show snackbar and navigate
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Logged out successfully'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//               // Navigate to initial page
//               Navigator.of(context).popUntil((route) => route.isFirst);
//               Navigator.of(context).pushReplacementNamed(AppRoutes.initial);
//             },
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _LogoutLoadingScreen extends StatelessWidget {
//   const _LogoutLoadingScreen();

//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(const Duration(seconds: 1), () {
//       Navigator.of(context).pop(); // Close loading screen after 1s
//     });

//     return const Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/config/routes/app_routes.dart';
import 'package:zkp_app/app/features/admin/home/presentation/bloc/bloc/admin_home_bloc.dart';
import 'package:zkp_app/app/features/admin/home/presentation/widgets/admin_classroom_card.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _teacherNameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _teacherNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<AdminHomeBloc>().add(
        FetchClassroomsEvent(token: "admin")); // or real token if available
  }

  void _showStatusAlert(BuildContext context,
      {required bool isSuccess, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showAddClassroomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Classroom'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Class Name',
                      hintText: 'Enter class name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter class name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter class description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter class description';
                      }
                      return null;
                    },
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _teacherNameController,
                    decoration: const InputDecoration(
                      labelText: 'Teacher Name',
                      hintText: 'Enter teacher name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter teacher name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Clear form and close dialog
                _nameController.clear();
                _descriptionController.clear();
                _teacherNameController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Submit the form
                  context.read<AdminHomeBloc>().add(
                        CreateClassroomEvent(
                          name: _nameController.text,
                          description: _descriptionController.text,
                          teacherName: _teacherNameController.text,
                        ),
                      );

                  // Clear form and close dialog
                  _nameController.clear();
                  _descriptionController.clear();
                  _teacherNameController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Retry by dispatching the fetch event again
                context.read<AdminHomeBloc>().add(
                      FetchClassroomsEvent(token: "admin"),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminHomeBloc, AdminHomeState>(
      listenWhen: (previous, current) =>
          previous.addStatus != current.addStatus &&
          (current.addStatus == AddClassroomStatus.success ||
              current.addStatus == AddClassroomStatus.failure),
      listener: (context, state) {
        if (state.addStatus == AddClassroomStatus.success) {
          _showStatusAlert(
            context,
            isSuccess: true,
            message: state.addMessage ?? 'Classroom added successfully',
          );
        } else if (state.addStatus == AddClassroomStatus.failure) {
          _showStatusAlert(
            context,
            isSuccess: false,
            message: state.addMessage ?? 'Failed to add classroom',
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          actions: [
            IconButton(
              onPressed: () {
                _confirmLogout(context);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddClassroomDialog,
          backgroundColor:
              const Color.fromARGB(255, 101, 246, 138), // Maroon red
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Classrooms',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF800000), // Maroon red
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<AdminHomeBloc, AdminHomeState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case ClassroomStatus.loading:
                        return const Center(child: CircularProgressIndicator());

                      case ClassroomStatus.failure:
                        return _buildErrorState(context);

                      case ClassroomStatus.success:
                        if (state.classrooms.isEmpty) {
                          return const Center(
                              child: Text('No classrooms available.'));
                        }

                        return Stack(
                          children: [
                            GridView.builder(
                              itemCount: state.classrooms.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) {
                                final classroom = state.classrooms[index];
                                return AdminClassroomCard(
                                  classroom: classroom,
                                );
                              },
                            ),
                            if (state.addStatus == AddClassroomStatus.loading)
                              Container(
                                color: Colors.black.withOpacity(0.3),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        );

                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // Close dialog
              // Show loading
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => const _LogoutLoadingScreen(),
              );
              // After delay, show snackbar and navigate
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate to initial page
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacementNamed(AppRoutes.initial);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _LogoutLoadingScreen extends StatelessWidget {
  const _LogoutLoadingScreen();

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop(); // Close loading screen after 1s
    });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
