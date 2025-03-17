// login_state.dart
part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final UserEntity user;

  LoginSuccessState({required this.user});
}

class LoginFailureState extends LoginState {
  final String message;

  LoginFailureState({required this.message});
}
