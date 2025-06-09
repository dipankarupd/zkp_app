import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/features/student/auth/domain/entity/student_entity.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/bloc/bloc/student_classroom_detail_bloc.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/widgets/classroom_content.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/widgets/dialog_helper.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/widgets/views.dart';
import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';

class StudentClassroomDetailPage extends StatefulWidget {
  const StudentClassroomDetailPage({Key? key}) : super(key: key);

  @override
  State<StudentClassroomDetailPage> createState() =>
      _StudentClassroomDetailPageState();
}

class _StudentClassroomDetailPageState
    extends State<StudentClassroomDetailPage> {
  late ClassroomEntity classroom;
  late String token;
  late StudentEntity student;
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetched) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null &&
          args.containsKey('classroom') &&
          args.containsKey('token') &&
          args.containsKey('student')) {
        classroom = args['classroom'] as ClassroomEntity;
        token = args['token'] as String;
        student = args['student'] as StudentEntity;
        context.read<ClassroomDetailBloc>().add(
              ClassroomDetailFetched(
                token: token,
                classroomId: classroom.id,
              ),
            );
        _hasFetched = true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Invalid classroom data')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classroom.name),
        elevation: 0,
      ),
      body: BlocConsumer<ClassroomDetailBloc, StudentClassroomDetailState>(
        listener: (context, state) {
          if (state is AttendanceMarkingInProgress) {
            DialogHelper.showLoadingDialog(context);
          } else if (state is AttendanceMarkedSuccess) {
            DialogHelper.dismissDialog(context);
            DialogHelper.showSuccessDialog(
              context: context,
              message: state.message,
              onSuccess: () {
                context.read<ClassroomDetailBloc>().add(
                      ClassroomDetailFetched(
                        token: token,
                        classroomId: classroom.id,
                      ),
                    );
              },
            );
          } else if (state is AttendanceMarkedFailure) {
            DialogHelper.dismissDialog(context);
            DialogHelper.showErrorDialog(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is ClassroomDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ClassroomDetailError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<ClassroomDetailBloc>().add(
                      ClassroomDetailFetched(
                        token: token,
                        classroomId: classroom.id,
                      ),
                    );
              },
            );
          } else if (state is ClassroomDetailLoaded) {
            return ClassroomDetailContent(
              classroom: classroom,
              detail: state.classroom,
              state: state,
              token: token,
              student: student,
            );
          }

          return const LoadingView(message: 'Loading classroom details...');
        },
      ),
    );
  }
}
