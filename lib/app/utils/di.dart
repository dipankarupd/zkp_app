import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:zkp_app/app/features/admin/home/data/repo/admin_repo_impl.dart';
import 'package:zkp_app/app/features/admin/home/data/source/admin_source.dart';
import 'package:zkp_app/app/features/admin/home/domain/repo/admin_repo.dart';
import 'package:zkp_app/app/features/admin/home/domain/usecases/create_class.dart';
import 'package:zkp_app/app/features/admin/home/domain/usecases/create_classroom.dart';
import 'package:zkp_app/app/features/admin/home/domain/usecases/get_classroom_detail.dart';
import 'package:zkp_app/app/features/admin/home/presentation/bloc/bloc/admin_home_bloc.dart';
import 'package:zkp_app/app/features/admin/home/presentation/bloc/classroom_detail/bloc/admin_classroom_detail_bloc.dart';
import 'package:zkp_app/app/features/student/auth/data/repo/user_repo_impl.dart';
import 'package:zkp_app/app/features/student/auth/data/source/user_data_source.dart';
import 'package:zkp_app/app/features/student/auth/domain/repo/user_repo.dart';
import 'package:zkp_app/app/features/student/auth/domain/usecase/login.dart';
import 'package:zkp_app/app/features/student/auth/domain/usecase/register.dart';
import 'package:zkp_app/app/features/student/auth/views/bloc/login/bloc/login_bloc.dart';
import 'package:zkp_app/app/features/student/auth/views/bloc/registration/bloc/bloc_bloc.dart';
import 'package:zkp_app/app/features/student/classroom/data/repo/classroom_repo_impl.dart';
import 'package:zkp_app/app/features/student/classroom/data/source/student_classroom_source.dart';
import 'package:zkp_app/app/features/student/classroom/domain/repo/classroom_repo.dart';
import 'package:zkp_app/app/features/student/classroom/domain/usecases/get_classroom_detail.dart';
import 'package:zkp_app/app/features/student/classroom/domain/usecases/get_upcoming_class.dart';
import 'package:zkp_app/app/features/student/classroom/domain/usecases/mark_attendance.dart';
import 'package:zkp_app/app/features/student/classroom/domain/usecases/verify.dart';
import 'package:zkp_app/app/features/student/classroom/presentation/bloc/bloc/student_classroom_detail_bloc.dart';
import 'package:zkp_app/app/features/student/home/data/repo/home_repo_impl.dart';
import 'package:zkp_app/app/features/student/home/data/source/home_data_source.dart';
import 'package:zkp_app/app/features/student/home/domain/repo/home_repo.dart';
import 'package:zkp_app/app/features/student/home/domain/usecase/get_classroom_for_student.dart';
import 'package:zkp_app/app/features/student/home/domain/usecase/get_classrooms.dart';
import 'package:zkp_app/app/features/student/home/domain/usecase/join_classroom.dart';
import 'package:zkp_app/app/features/student/home/view/bloc/bloc/student_home_bloc.dart';

final serviceLocator = GetIt.instance;

void initDependencies() {
  serviceLocator.registerLazySingleton(() => Dio());
  _initRegistration();
  _initLogin();
  _initStudentHome();
  _initStudentClassroom();

  _initAdmin();
}

void _initRegistration() {
  serviceLocator
    ..registerLazySingleton<UserDataSource>(
      () => UserDataSourceImpl(dio: serviceLocator()),
    )
    ..registerLazySingleton<UserRepo>(
      () => UserRepoImpl(source: serviceLocator()),
    )
    ..registerLazySingleton<Register>(
      () => Register(repo: serviceLocator()),
    )
    ..registerLazySingleton<RegistrationBloc>(
      () => RegistrationBloc(serviceLocator()),
    );
}

void _initLogin() {
  serviceLocator
    ..registerLazySingleton<Login>(
      () => Login(repository: serviceLocator()),
    )
    ..registerLazySingleton(
      () => LoginBloc(
        loginUseCase: serviceLocator(),
      ),
    );
}

void _initStudentHome() {
  serviceLocator
    ..registerLazySingleton<StudentHomeDataSource>(
      () => StudentHomeDataSourceImpl(dio: serviceLocator()),
    )
    ..registerLazySingleton<StudentHomeRepo>(
        () => StudentHomeRepoImpl(source: serviceLocator()))
    ..registerLazySingleton<GetClassrooms>(
        () => GetClassrooms(repo: serviceLocator()))
    ..registerLazySingleton<GetClassroomForStudent>(
        () => GetClassroomForStudent(repo: serviceLocator()))
    ..registerLazySingleton<JoinClassroom>(
      () => JoinClassroom(
        repo: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => StudentHomeBloc(
        getClassrooms: serviceLocator(),
        getClassroomsForStudent: serviceLocator(),
        joinClassroom: serviceLocator(),
      ),
    );
}

void _initStudentClassroom() {
  serviceLocator
    ..registerLazySingleton<StudentClassroomSource>(
      () => StudentClassroomSourceImpl(dio: serviceLocator()),
    )
    ..registerLazySingleton<StudentClassroomRepo>(
      () => StudentClassroomRepoImpl(source: serviceLocator()),
    )
    ..registerLazySingleton<GetClassroomDetail>(
      () => GetClassroomDetail(repo: serviceLocator()),
    )
    ..registerLazySingleton<GetUpcomingClass>(
      () => GetUpcomingClass(repo: serviceLocator()),
    )
    ..registerLazySingleton<MarkAttendance>(
      () => MarkAttendance(
        repo: serviceLocator(),
      ),
    )
    ..registerLazySingleton<Verify>(
      () => Verify(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<ClassroomDetailBloc>(
      () => ClassroomDetailBloc(
        getClassroomDetail: serviceLocator(),
        getUpcomingClass: serviceLocator(),
        markAttendance: serviceLocator(),
        verify: serviceLocator(),
      ),
    );
}

void _initAdmin() {
  serviceLocator
    ..registerLazySingleton<AdminSource>(
      () => AdminSourceImpl(
        dio: serviceLocator(),
      ),
    )
    ..registerLazySingleton<AdminRepo>(
      () => AdminRepoImpl(
        source: serviceLocator(),
      ),
    )
    ..registerLazySingleton<CreateClassroom>(
      () => CreateClassroom(
        repo: serviceLocator(),
      ),
    )
    ..registerLazySingleton<AdminHomeBloc>(
      () => AdminHomeBloc(
        getClassrooms: serviceLocator(),
        createClass: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetClassroomDetailAdmin>(
      () => GetClassroomDetailAdmin(
        repo: serviceLocator(),
      ),
    )
    ..registerLazySingleton<CreateClass>(
      () => CreateClass(
        repo: serviceLocator(),
      ),
    )
    ..registerFactory<AdminClassroomDetailBloc>(
      () => AdminClassroomDetailBloc(
        getClassroomDetail: serviceLocator(),
        createClass: serviceLocator(),
      ),
    );
}
