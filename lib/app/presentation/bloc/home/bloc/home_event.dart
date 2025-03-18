part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class MarkAttendanceEvent extends HomeEvent {
  final String token;
  final double latitude;
  final double longitude;

  MarkAttendanceEvent({
    required this.token,
    required this.latitude,
    required this.longitude,
  });
}
