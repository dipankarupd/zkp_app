import 'package:flutter/material.dart';
import 'package:zkp_app/app/config/routes/app_routes.dart';
import 'package:zkp_app/app/features/admin/home/domain/entity/classroom_detail_entity.dart';
import 'package:zkp_app/app/features/student/auth/domain/entity/student_entity.dart';
import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';

class ClassroomCard extends StatelessWidget {
  final ClassroomEntity classroom;
  final StudentEntity student;
  final String token;
  final bool showJoin;
  final VoidCallback? onJoin;

  const ClassroomCard({
    super.key,
    required this.classroom,
    this.showJoin = false,
    this.onJoin,
    required this.token,
    required this.student,
  });

  void _navigateToDetails(BuildContext context) {
    // Replace with your actual navigation logic
    Navigator.pushNamed(
      context,
      AppRoutes.classroomDetail, // Update with your route name
      arguments: {
        'classroom': classroom,
        'token': token,
        'student': student,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardContent = Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Image.asset('assets/book.png')),
            const SizedBox(height: 8),
            Text(
              classroom.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              classroom.teacherName,
              style: TextStyle(
                fontSize: 13,
                color: Colors.red[700],
              ),
            ),
            if (showJoin) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Join',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    return showJoin
        ? cardContent
        : InkWell(
            onTap: () => _navigateToDetails(context),
            borderRadius: BorderRadius.circular(12),
            child: cardContent,
          );
  }
}
