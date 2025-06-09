// import 'package:flutter/material.dart';
// import 'package:zkp_app/app/config/routes/app_routes.dart';
// import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';

// class AdminClassroomCard extends StatelessWidget {
//   final ClassroomEntity classroom;
//   final VoidCallback onJoin;

//   const AdminClassroomCard({
//     super.key,
//     required this.classroom,
//     required this.onJoin,
//   });

//   void _navigateToDetails(BuildContext context) {
//     // Replace with your actual navigation logic
//     // Navigator.pushNamed(
//     //   context,
//     //   AppRoutes.classroomDetail, // Update with your route name
//     //   arguments: {
//     //     'classroom': classroom,
//     //     'token': token,
//     //   },
//     // );
//     print('object');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cardContent = Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(child: Image.asset('assets/book.png')),
//             const SizedBox(height: 8),
//             Text(
//               classroom.name,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               classroom.teacherName,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.red[700],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

//     return cardContent;
//   }
// }

import 'package:flutter/material.dart';
import 'package:zkp_app/app/config/routes/app_routes.dart';
import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';

class AdminClassroomCard extends StatelessWidget {
  final ClassroomEntity classroom;

  const AdminClassroomCard({
    super.key,
    required this.classroom,
  });

  void _navigateToDetails(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.adminClassroomDetail,
      arguments: classroom.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: Card(
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
            ],
          ),
        ),
      ),
    );
  }
}
