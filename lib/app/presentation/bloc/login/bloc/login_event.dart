part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginSubmittedEvent extends LoginEvent {
  final String token;

  LoginSubmittedEvent({required this.token});
}
