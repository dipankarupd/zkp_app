import 'package:flutter/material.dart';
import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';

class ClassroomHeader extends StatelessWidget {
  final ClassroomEntity classroom;

  const ClassroomHeader({Key? key, required this.classroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildClassroomImage(),
        const SizedBox(height: 24),
        _buildStudentInfo(),
      ],
    );
  }

  Widget _buildClassroomImage() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/book.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStudentInfo() {
    return Column(
      children: [
        Text(
          classroom.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Class: ${classroom.name}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Teacher: ${classroom.teacherName}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
