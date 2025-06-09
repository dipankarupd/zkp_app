// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:zkp_app/app/config/routes/app_routes.dart';
// import 'package:zkp_app/app/features/admin/home/domain/entity/classroom_detail_entity.dart';
// import 'package:zkp_app/app/features/admin/home/presentation/bloc/classroom_detail/bloc/admin_classroom_detail_bloc.dart';
// import 'package:zkp_app/app/features/admin/home/domain/usecases/get_classroom_detail.dart';
// import 'package:zkp_app/app/features/admin/home/domain/usecases/create_class.dart';
// import 'package:zkp_app/app/features/admin/home/presentation/widgets/add_class_dialog.dart';
// import 'package:zkp_app/app/utils/di.dart';

// class AdminClassroomDetailPage extends StatelessWidget {
//   const AdminClassroomDetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final classroomId = ModalRoute.of(context)!.settings.arguments as String;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Classroom Details'),
//         elevation: 0,
//       ),
//       body: BlocProvider(
//         create: (context) => AdminClassroomDetailBloc(
//           getClassroomDetail: serviceLocator<GetClassroomDetailAdmin>(),
//           createClass: serviceLocator<CreateClass>(),
//         )..add(FetchClassroomDetailEvent(classroomId: classroomId)),
//         child:
//             BlocConsumer<AdminClassroomDetailBloc, AdminClassroomDetailState>(
//           listenWhen: (previous, current) =>
//               previous.errorMessage != current.errorMessage ||
//               previous.successMessage != current.successMessage,
//           listener: (context, state) {
//             // Show error message if present
//             if (state.errorMessage != null) {
//               ScaffoldMessenger.of(context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(
//                   SnackBar(
//                     content: Text(state.errorMessage!),
//                     backgroundColor: Colors.red,
//                     action: SnackBarAction(
//                       label: 'Dismiss',
//                       textColor: Colors.white,
//                       onPressed: () {
//                         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                       },
//                     ),
//                   ),
//                 );

//               // Clear the error message after showing it
//               Future.delayed(
//                 Duration.zero,
//                 () => context
//                     .read<AdminClassroomDetailBloc>()
//                     .add(ClearErrorMessageEvent()),
//               );
//             }

//             // Show success message if present
//             if (state.successMessage != null) {
//               ScaffoldMessenger.of(context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(
//                   SnackBar(
//                     content: Text(state.successMessage!),
//                     backgroundColor: Colors.green,
//                   ),
//                 );

//               // Clear the success message after showing it
//               Future.delayed(
//                 Duration.zero,
//                 () => context
//                     .read<AdminClassroomDetailBloc>()
//                     .add(ClearErrorMessageEvent()),
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state.status == ClassroomDetailStatus.loading) {
//               return const Center(child: LoadingWidget());
//             } else if (state.status == ClassroomDetailStatus.failure) {
//               return const Center(
//                 child: Text(
//                   'An error occurred',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               );
//             } else if (state.status == ClassroomDetailStatus.success &&
//                 state.classroomDetail != null) {
//               final classroomDetail = state.classroomDetail!;
//               final students = classroomDetail.students ?? [];

//               return Column(
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Center(
//                             child: Column(
//                               children: [
//                                 const Image(
//                                   image: AssetImage('assets/book.png'),
//                                   height: 120,
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   classroomDetail.name,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .headlineMedium
//                                       ?.copyWith(fontWeight: FontWeight.bold),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           _buildInfoSection(context, 'Description',
//                               classroomDetail.description),
//                           const SizedBox(height: 16),
//                           _buildInfoSection(
//                               context, 'Teacher', classroomDetail.teacherName),
//                           const SizedBox(height: 16),
//                           _buildInfoSection(context, 'Classes Conducted',
//                               classroomDetail.classesConducted.toString()),
//                           const SizedBox(height: 24),
//                           _buildStudentCountIndicator(context, students.length),
//                           const SizedBox(height: 24),
//                           Text(
//                             'Students',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleLarge
//                                 ?.copyWith(fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 8),
//                           _buildStudentList(context, students),
//                           const SizedBox(
//                               height: 100), // Space before button area
//                         ],
//                       ),
//                     ),
//                   ),
//                   const Divider(height: 1),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12),
//                     color: Colors.white,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () =>
//                                 _showAddClassDialog(context, classroomId),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green.shade600,
//                               foregroundColor: Colors.white,
//                             ),
//                             child: const Text("Add a Class"),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return const Center(
//                 child: Text('No data available'),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   void _showAddClassDialog(BuildContext context, String classroomId) {
//     showDialog(
//       context: context,
//       builder: (_) => AddClassDialog(
//         onSubmit: (startTime, endTime, meetLink) {
//           // Dispatch CreateClassEvent to the bloc
//           BlocProvider.of<AdminClassroomDetailBloc>(context).add(
//             CreateClassEvent(
//               startTime: startTime,
//               endTime: endTime,
//               meetLink: meetLink,
//               classroomId: classroomId,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInfoSection(BuildContext context, String title, String content) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blueGrey,
//               ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           content,
//           style: Theme.of(context).textTheme.bodyLarge,
//         ),
//       ],
//     );
//   }

//   Widget _buildStudentCountIndicator(BuildContext context, int count) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.blue.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.people, color: Colors.blue),
//           const SizedBox(width: 8),
//           Text(
//             'Total Students: $count',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.blue,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStudentList(BuildContext context, List<Student> students) {
//     if (students.isEmpty) {
//       return const Card(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Center(
//             child: Text('No students enrolled yet'),
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: students.length,
//       itemBuilder: (context, index) {
//         final student = students[index];

//         final name = student.name;
//         final initial =
//             name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';

//         return GestureDetector(
//           onTap: () {
//             Navigator.of(context).pushNamed(
//               AppRoutes.studentDetail,
//               arguments: student,
//             );
//           },
//           child: Card(
//             margin: const EdgeInsets.only(bottom: 8),
//             child: ListTile(
//               leading: CircleAvatar(
//                 child: Text(initial),
//               ),
//               title: Text(name),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class LoadingWidget extends StatelessWidget {
//   const LoadingWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const CircularProgressIndicator();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/config/routes/app_routes.dart';
import 'package:zkp_app/app/features/admin/home/domain/entity/classroom_detail_entity.dart';
import 'package:zkp_app/app/features/admin/home/presentation/bloc/classroom_detail/bloc/admin_classroom_detail_bloc.dart';
import 'package:zkp_app/app/features/admin/home/domain/usecases/get_classroom_detail.dart';
import 'package:zkp_app/app/features/admin/home/domain/usecases/create_class.dart';
import 'package:zkp_app/app/features/admin/home/presentation/widgets/add_class_dialog.dart';
import 'package:zkp_app/app/utils/di.dart';

class AdminClassroomDetailPage extends StatelessWidget {
  const AdminClassroomDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final classroomId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classroom Details'),
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => AdminClassroomDetailBloc(
          getClassroomDetail: serviceLocator<GetClassroomDetailAdmin>(),
          createClass: serviceLocator<CreateClass>(),
        )..add(FetchClassroomDetailEvent(classroomId: classroomId)),
        child:
            BlocConsumer<AdminClassroomDetailBloc, AdminClassroomDetailState>(
          listenWhen: (previous, current) =>
              previous.successMessage != current.successMessage,
          listener: (context, state) {
            // Only show success message if present
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.successMessage!),
                    backgroundColor: Colors.green,
                  ),
                );

              // Clear the success message after showing it
              Future.delayed(
                Duration.zero,
                () => context
                    .read<AdminClassroomDetailBloc>()
                    .add(ClearErrorMessageEvent()),
              );
            }
          },
          builder: (context, state) {
            if (state.status == ClassroomDetailStatus.loading) {
              return const Center(child: LoadingWidget());
            } else if (state.status == ClassroomDetailStatus.failure) {
              return _buildErrorState(context, classroomId);
            } else if (state.status == ClassroomDetailStatus.success &&
                state.classroomDetail != null) {
              final classroomDetail = state.classroomDetail!;
              final students = classroomDetail.students ?? [];

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                const Image(
                                  image: AssetImage('assets/book.png'),
                                  height: 120,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  classroomDetail.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildInfoSection(context, 'Description',
                              classroomDetail.description),
                          const SizedBox(height: 16),
                          _buildInfoSection(
                              context, 'Teacher', classroomDetail.teacherName),
                          const SizedBox(height: 16),
                          _buildInfoSection(context, 'Classes Conducted',
                              classroomDetail.classesConducted.toString()),
                          const SizedBox(height: 24),
                          _buildStudentCountIndicator(context, students.length),
                          const SizedBox(height: 24),
                          Text(
                            'Students',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildStudentList(context, students),
                          const SizedBox(
                              height: 100), // Space before button area
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                _showAddClassDialog(context, classroomId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Add a Class"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('No data available'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String classroomId) {
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
                context.read<AdminClassroomDetailBloc>().add(
                      FetchClassroomDetailEvent(classroomId: classroomId),
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

  void _showAddClassDialog(BuildContext context, String classroomId) {
    showDialog(
      context: context,
      builder: (_) => AddClassDialog(
        onSubmit: (startTime, endTime, meetLink) {
          // Dispatch CreateClassEvent to the bloc
          BlocProvider.of<AdminClassroomDetailBloc>(context).add(
            CreateClassEvent(
              startTime: startTime,
              endTime: endTime,
              meetLink: meetLink,
              classroomId: classroomId,
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildStudentCountIndicator(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.people, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            'Total Students: $count',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList(BuildContext context, List<Student> students) {
    if (students.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text('No students enrolled yet'),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];

        final name = student.name;
        final initial =
            name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';

        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.studentDetail,
              arguments: student,
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(initial),
              ),
              title: Text(name),
            ),
          ),
        );
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}
