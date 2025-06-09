import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zkp_app/app/features/student/auth/domain/entity/student_entity.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/classs_entity.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/bloc/bloc/student_classroom_detail_bloc.dart';

class UpcomingClassCard extends StatelessWidget {
  final ClassroomDetailLoaded state;
  final String token;
  final String classroomId;
  final StudentEntity student;

  const UpcomingClassCard({
    Key? key,
    required this.state,
    required this.token,
    required this.classroomId,
    required this.student,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state.upcomingClassStatus) {
      case UpcomingClassStatus.loading:
        return _buildLoadingCard();
      case UpcomingClassStatus.loaded:
        return _buildUpcomingClassCard(context, state.upcomingClass!);
      case UpcomingClassStatus.noClass:
        return _buildNoClassCard();
      default:
        return _buildNoClassCard();
    }
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: const Center(
        child: Column(
          children: [
            Text(
              'Upcoming Class',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('Loading class information...'),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingClassCard(
      BuildContext context, ClassEntity upcomingClass) {
    final startTime = DateFormat('HH:mm, dd MMM yyyy').format(
      DateTime.parse(upcomingClass.startTime.toIso8601String()),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Class',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Class ID: ${upcomingClass.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start Time: $startTime',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Directly call the bloc to mark attendance without confirmation dialog
                  context.read<ClassroomDetailBloc>().add(
                        MarkAttendanceRequested(
                          token: token,
                          classId: upcomingClass.id,
                          latitude: student.location.latitude,
                          longitude: student.location.longitude,
                        ),
                      );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Mark'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoClassCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: const Column(
        children: [
          Text(
            'Upcoming Class',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'No upcoming class',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 2,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
