import 'package:flutter/material.dart';
import 'package:zkp_app/app/features/student/auth/domain/entity/student_entity.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/get_classroom_detail.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/bloc/bloc/student_classroom_detail_bloc.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/widgets/attendance_card.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/widgets/classroom_header.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/widgets/upcoming_class.dart';
import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';

class ClassroomDetailContent extends StatelessWidget {
  final ClassroomEntity classroom;
  final StudentClassroomDetailEntity detail;
  final ClassroomDetailLoaded state;
  final String token;
  final StudentEntity student;

  const ClassroomDetailContent({
    Key? key,
    required this.classroom,
    required this.detail,
    required this.state,
    required this.token,
    required this.student,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final attendancePercent = detail.presentCount / detail.totalClassTaken;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClassroomHeader(classroom: classroom),
          const SizedBox(height: 32),
          AttendanceCard(
            detail: detail,
            attendancePercent: attendancePercent,
          ),
          const SizedBox(height: 30),
          UpcomingClassCard(
            state: state,
            token: token,
            classroomId: classroom.id,
            student: student,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
