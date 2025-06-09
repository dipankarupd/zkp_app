import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/config/routes/app_routes.dart';
import 'package:zkp_app/app/features/admin/home/presentation/bloc/bloc/admin_home_bloc.dart';
import 'package:zkp_app/app/features/admin/home/presentation/bloc/classroom_detail/bloc/admin_classroom_detail_bloc.dart';
import 'package:zkp_app/app/features/admin/home/presentation/pages/admin_home_page.dart';
import 'package:zkp_app/app/features/admin/home/presentation/pages/classroom_detail_page_admin.dart';
import 'package:zkp_app/app/features/admin/home/presentation/pages/individual_student_detail_page.dart';
import 'package:zkp_app/app/features/admin/login_page.dart';
import 'package:zkp_app/app/features/student/auth/views/bloc/login/bloc/login_bloc.dart';
import 'package:zkp_app/app/features/student/auth/views/bloc/registration/bloc/bloc_bloc.dart';
import 'package:zkp_app/app/features/student/auth/views/pages/login/login_page.dart';
import 'package:zkp_app/app/features/student/auth/views/pages/register/register_page.dart';
import 'package:zkp_app/app/features/student/auth/views/pages/register/show_map_page.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/bloc/bloc/student_classroom_detail_bloc.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/pages/student_classroom_detail.dart';
import 'package:zkp_app/app/features/student/home/view/bloc/bloc/student_home_bloc.dart';
import 'package:zkp_app/app/features/student/home/view/pages/student_home.dart';
import 'package:zkp_app/app/features/student/home/view/pages/update_map_page.dart';
import 'package:zkp_app/app/utils/di.dart';

void main() {
  // Initialize DI first
  initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegistrationBloc>(
          create: (context) => serviceLocator<RegistrationBloc>(),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => serviceLocator<LoginBloc>(),
        ),
        BlocProvider<StudentHomeBloc>(
          create: (context) => serviceLocator<StudentHomeBloc>(),
        ),
        BlocProvider<ClassroomDetailBloc>(
          create: (context) => serviceLocator<ClassroomDetailBloc>(),
        ),
        BlocProvider<AdminHomeBloc>(
          create: (context) => serviceLocator<AdminHomeBloc>(),
        ),
        BlocProvider<AdminClassroomDetailBloc>(
          create: (context) => serviceLocator<AdminClassroomDetailBloc>(),
        ),
        // Add other BLoCs similarly if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.initial,
        routes: {
          AppRoutes.initial: (context) => LoginPage(),
          AppRoutes.registrationPage: (context) => RegistrationPage(),
          AppRoutes.registerMapPage: (context) => const RegistrationMapPage(),
          AppRoutes.studentHomePage: (context) => const StudentHomePage(),
          AppRoutes.classroomDetail: (context) =>
              const StudentClassroomDetailPage(),
          AppRoutes.adminLoginPage: (context) => const AdminLoginPage(),
          AppRoutes.adminHomePage: (context) => const AdminHomePage(),
          AppRoutes.adminClassroomDetail: (context) =>
              const AdminClassroomDetailPage(),
          AppRoutes.studentDetail: (context) => const IndividualStudentDetail(),
          AppRoutes.updateMap: (context) => const UpdateMapPage(),
        },
      ),
    );
  }
}
