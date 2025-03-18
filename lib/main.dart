import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/config/routes/app_routes.dart';
import 'package:zkp_app/app/presentation/bloc/home/bloc/home_bloc.dart';
import 'package:zkp_app/app/presentation/bloc/login/bloc/login_bloc.dart';
import 'package:zkp_app/app/presentation/bloc/registration/bloc/bloc_bloc.dart';
import 'package:zkp_app/app/presentation/views/home/home_page.dart';
import 'package:zkp_app/app/presentation/views/login/login_page.dart';
import 'package:zkp_app/app/presentation/views/registration/registration_page.dart';
import 'package:zkp_app/app/presentation/views/registration/show_map_page.dart';
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
        BlocProvider<HomeBloc>(
          create: (context) => serviceLocator<HomeBloc>(),
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
          AppRoutes.home: (context) => const HomePageNew()
        },
      ),
    );
  }
}
