import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:zkp_app/app/domain/entity/register_user_entity.dart';
import 'package:zkp_app/app/domain/usecases/update.dart';
import 'package:zkp_app/app/domain/usecases/verify.dart';
import 'package:zkp_app/app/utils/logger_util.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Verify verifyUsecase;
  final Update updateUsecase;

  HomeBloc({
    required this.verifyUsecase,
    required this.updateUsecase,
  }) : super(AttendanceInitialState()) {
    on<MarkAttendanceEvent>(_handleMarkAttendance);
  }

  Future<void> _handleMarkAttendance(
    MarkAttendanceEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(AttendanceLoadingState());

      // Get current position
      Position currentPosition = await _getCurrentPosition();

      LoggerUtils.logGeneral(
        'Positions: ${currentPosition.latitude} ${currentPosition.longitude} ${event.latitude} ${event.longitude}',
      );
      // Calculate distance
      double distanceInMeters = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        event.latitude,
        event.longitude,
      );

      // Convert to integer (assuming distance in meters)
      // considering 500m
      int distance = distanceInMeters.round() * 100;
      // Verify distance
      final verifyResult = await verifyUsecase(
        VerifyParams(distance: distance),
      );

      return verifyResult.fold(
        (failure) => emit(AttendanceFailureState(message: failure.message)),
        (result) async {
          // Convert result to boolean (0 = true, 1 = false)
          bool isVerified = result.result == "1";

          // Update user attendance
          final now = DateTime.now().toIso8601String() + 'Z';
          print('NOW: $now');
          final updateResult = await updateUsecase(
            UpdateParams(
              token: event.token,
              date: now,
              isPresent: isVerified,
            ),
          );

          return updateResult.fold(
            (failure) => emit(AttendanceFailureState(message: failure.message)),
            (updatedUser) => emit(AttendanceSuccessState(
              isVerified: isVerified,
              user: updatedUser,
            )),
          );
        },
      );
    } catch (e) {
      emit(AttendanceFailureState(message: e.toString()));
    }
  }

  Future<Position> _getCurrentPosition() async {
    bool servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
