part of 'bloc_bloc.dart';

enum RegistrationStatus { initial, loading, success, failure }

class RegistrationState {
  final String username;
  final double? latitude;
  final double? longitude;
  final RegistrationStatus status;
  final String? errorMessage;
  final int? token;

  const RegistrationState({
    required this.username,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.errorMessage,
    required this.token,
  });

  factory RegistrationState.initial() {
    return const RegistrationState(
      username: '',
      latitude: null,
      longitude: null,
      status: RegistrationStatus.initial,
      errorMessage: null,
      token: null,
    );
  }

  RegistrationState copyWith({
    String? username,
    double? latitude,
    double? longitude,
    RegistrationStatus? status,
    String? errorMessage,
    int? token,
  }) {
    return RegistrationState(
      username: username ?? this.username,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      errorMessage: errorMessage,
      token: token ?? this.token,
    );
  }
}
