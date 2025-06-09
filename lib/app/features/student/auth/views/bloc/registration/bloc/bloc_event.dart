part of 'bloc_bloc.dart';

@immutable
sealed class RegistrationEvent {}

class UserNameChangedEvent extends RegistrationEvent {
  final String username;

  UserNameChangedEvent({required this.username});
}

class LocationSelectedEvent extends RegistrationEvent {
  final double latitude;
  final double longitude;

  LocationSelectedEvent({
    required this.latitude,
    required this.longitude,
  });
}

class RegistrationSubmittedEvent extends RegistrationEvent {}
