part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class AttendanceInitialState extends HomeState {}

class AttendanceLoadingState extends HomeState {}

class AttendanceSuccessState extends HomeState {
  final bool isVerified;
  final UserEntity user;

  AttendanceSuccessState({
    required this.isVerified,
    required this.user,
  });
}

class AttendanceFailureState extends HomeState {
  final String message;

  AttendanceFailureState({required this.message});
}
