import 'package:flutter/material.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/get_classroom_detail.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/widgets/attendance_chart_widget.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/widgets/attendance_indicator_widget.dart';

class AttendanceCard extends StatelessWidget {
  final StudentClassroomDetailEntity detail;
  final double attendancePercent;

  const AttendanceCard({
    Key? key,
    required this.detail,
    required this.attendancePercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
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
      ),
      child: Column(
        children: [
          const Text(
            'Attendance Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AttendanceChart(attendancePercent: attendancePercent),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AttendanceIndicator(
                    label: 'Total Classes',
                    value: detail.totalClassTaken,
                    max: detail.totalClassTaken,
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  AttendanceIndicator(
                    label: 'Present',
                    value: detail.presentCount,
                    max: detail.totalClassTaken,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  AttendanceIndicator(
                    label: 'Absent',
                    value: detail.absentCount,
                    max: detail.totalClassTaken,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
