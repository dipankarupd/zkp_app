import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/config/routes/app_routes.dart';
import 'package:zkp_app/app/presentation/bloc/registration/bloc/bloc_bloc.dart';
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
        // Add other BLoCs similarly if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.registrationPage,
        routes: {
          AppRoutes.registrationPage: (context) => RegistrationPage(),
          AppRoutes.registerMapPage: (context) => const RegistrationMapPage(),
        },
      ),
    );
  }
}
