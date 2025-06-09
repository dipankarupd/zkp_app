import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/config/routes/app_routes.dart';
import 'package:zkp_app/app/features/student/auth/domain/entity/student_entity.dart';
import 'package:zkp_app/app/features/student/home/view/bloc/bloc/student_home_bloc.dart';
import 'package:zkp_app/app/features/student/home/view/widgets/classroom_card.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  late StudentEntity student;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    student = ModalRoute.of(context)?.settings.arguments as StudentEntity;
    context.read<StudentHomeBloc>().add(
          FetchClassroomsEvent(
            token: student.token.toString(),
          ),
        );
  }

  void _onJoinClassroom(String classroomId) {
    context.read<StudentHomeBloc>().add(
          JoinClassroomEvent(
            classroomId: classroomId,
            token: student.token.toString(),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentHomeBloc, StudentHomeState>(
      listenWhen: (previous, current) =>
          previous.joinStatus != current.joinStatus &&
          (current.joinStatus == JoinClassroomStatus.success ||
              current.joinStatus == JoinClassroomStatus.failure),
      listener: (context, state) {
        if (state.joinStatus == JoinClassroomStatus.success) {
          _showStatusAlert(
            context,
            isSuccess: true,
            message: state.joinMessage ?? 'Successfully joined classroom',
          );
        } else if (state.joinStatus == JoinClassroomStatus.failure) {
          _showStatusAlert(
            context,
            isSuccess: false,
            message: 'Something went wrong.!',
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.updateMap);
              },
              icon: Icon(Icons.update),
            ),
            IconButton(
              onPressed: () {
                _confirmLogout(context);
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome ${student.name}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green[600], // parrot green
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<StudentHomeBloc, StudentHomeState>(
                buildWhen: (previous, current) =>
                    previous.filter != current.filter,
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Classrooms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF800000), // maroon red
                        ),
                      ),
                      DropdownButton<ClassroomFilter>(
                        value: state.filter,
                        items: const [
                          DropdownMenuItem(
                              value: ClassroomFilter.all, child: Text('All')),
                          DropdownMenuItem(
                              value: ClassroomFilter.joined,
                              child: Text('Joined')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            context.read<StudentHomeBloc>().add(
                                  ChangeFilterEvent(
                                    filter: value,
                                    token: student.token.toString(),
                                  ),
                                );
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<StudentHomeBloc, StudentHomeState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status ||
                      previous.classrooms != current.classrooms,
                  builder: (context, state) {
                    switch (state.status) {
                      case ClassroomStatus.loading:
                        return const Center(child: CircularProgressIndicator());
                      case ClassroomStatus.failure:
                        return Center(
                            child: Text('Something went wrong. Try again!'));
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
                                return ClassroomCard(
                                  classroom: classroom,
                                  token: student.token.toString(),
                                  student: student,
                                  // Show Join button only when viewing "All" classrooms
                                  showJoin: state.filter == ClassroomFilter.all,
                                  onJoin: () => _onJoinClassroom(classroom.id),
                                );
                              },
                            ),
                            if (state.joinStatus == JoinClassroomStatus.loading)
                              Container(
                                color: Colors.black.withOpacity(0.3),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        );
                      default:
                        return const SizedBox();
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
