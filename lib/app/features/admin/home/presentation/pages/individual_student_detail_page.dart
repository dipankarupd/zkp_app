import 'package:flutter/material.dart';
import 'package:zkp_app/app/features/admin/home/domain/entity/classroom_detail_entity.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/widgets/attendance_chart_widget.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/widgets/attendance_indicator_widget.dart';

class IndividualStudentDetail extends StatelessWidget {
  const IndividualStudentDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final student = ModalRoute.of(context)!.settings.arguments as Student;

    // Calculate total classes for display
    final int totalClasses = student.presentCount + student.absentCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Student Image
              CircleAvatar(
                radius: 60,
                backgroundImage: const AssetImage('assets/man.jpg'),
              ),

              const SizedBox(height: 16),

              // Student Name
              Text(
                student.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Student ID
              Text(
                'ID: ${student.id}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 32),

              // Attendance Summary Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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

                      // Attendance Chart
                      AttendanceChart(
                        attendancePercent: student.attendancePercentage / 100,
                      ),

                      const SizedBox(height: 32),

                      // Attendance Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AttendanceIndicator(
                            label: 'Present',
                            value: student.presentCount,
                            max: totalClasses,
                            color: Colors.green,
                          ),
                          AttendanceIndicator(
                            label: 'Absent',
                            value: student.absentCount,
                            max: totalClasses,
                            color: Colors.red,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Total Classes Info
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calendar_month,
                                color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              'Total Classes: $totalClasses',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
