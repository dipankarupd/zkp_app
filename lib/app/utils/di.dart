import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:zkp_app/app/data/datasource/remote_source.dart';
import 'package:zkp_app/app/data/repository/app_repository_impl.dart';
import 'package:zkp_app/app/domain/repository/app_repository.dart';
import 'package:zkp_app/app/domain/usecases/login.dart';
import 'package:zkp_app/app/domain/usecases/register.dart';
import 'package:zkp_app/app/domain/usecases/update.dart';
import 'package:zkp_app/app/domain/usecases/verify.dart';
import 'package:zkp_app/app/presentation/bloc/home/bloc/home_bloc.dart';
import 'package:zkp_app/app/presentation/bloc/login/bloc/login_bloc.dart';
import 'package:zkp_app/app/presentation/bloc/registration/bloc/bloc_bloc.dart';

final serviceLocator = GetIt.instance;

void initDependencies() {
  serviceLocator.registerLazySingleton(() => Dio());
  _initRegistration();
  _initLogin();
  _initHome();
}

// void _initRegistration() {
//   serviceLocator
//     ..registerFactory<RemoteDataSource>(
//       () => RemoteDataSourceImpl(dio: serviceLocator()),
//     )
//     ..registerFactory<AppRepository>(
//       () => AppRepositoryImpl(source: serviceLocator()),
//     )
//     ..registerFactory<Register>(
//       () => Register(repo: serviceLocator()),
//     )
//     ..registerLazySingleton<RegistrationBloc>(
//       () => RegistrationBloc(serviceLocator()),
//     );
// }

// void _initLogin() {
//   serviceLocator
//     ..registerFactory<Login>(
//       () => Login(repository: serviceLocator()),
//     )
//     ..registerLazySingleton(() => LoginBloc(loginUseCase: serviceLocator()));
// }

// void _initHome() {
//   serviceLocator
//     ..registerFactory<Update>(
//       () => Update(
//         repository: serviceLocator(),
//       ),
//     )
//     ..registerFactory<Verify>(
//       () => Verify(
//         repository: serviceLocator(),
//       ),
//     )
//     ..registerLazySingleton<HomeBloc>(
//       () => HomeBloc(
//         verifyUsecase: serviceLocator(),
//         updateUsecase: serviceLocator(),
//       ),
//     );
// }

void _initRegistration() {
  serviceLocator
    ..registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(dio: serviceLocator()),
    )
    ..registerLazySingleton<AppRepository>(
      () => AppRepositoryImpl(source: serviceLocator()),
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
    ..registerLazySingleton(() => LoginBloc(loginUseCase: serviceLocator()));
}

void _initHome() {
  serviceLocator
    ..registerLazySingleton<Update>(
      () => Update(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<Verify>(
      () => Verify(
        repository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<HomeBloc>(
      () => HomeBloc(
        verifyUsecase: serviceLocator(),
        updateUsecase: serviceLocator(),
      ),
    );
}
