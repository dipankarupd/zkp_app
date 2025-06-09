import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/get_classroom_detail.dart';
import 'package:zkp_app/app/features/student/classroom/domain/usecases/get_classroom_detail.dart';
import 'package:zkp_app/app/features/student/classroom/domain/entity/classs_entity.dart';
import 'package:zkp_app/app/features/student/classroom/domain/usecases/get_upcoming_class.dart';
import 'package:zkp_app/app/features/student/classroom/domain/usecases/mark_attendance.dart';
import 'package:zkp_app/app/features/student/classroom/domain/usecases/verify.dart';
import 'package:zkp_app/app/utils/logger_util.dart';

part 'student_classroom_detail_event.dart';
part 'student_classroom_detail_state.dart';

class ClassroomDetailBloc
    extends Bloc<StudentClassroomDetailEvent, StudentClassroomDetailState> {
  final GetClassroomDetail getClassroomDetail;
  final GetUpcomingClass getUpcomingClass;
  final MarkAttendance markAttendance;
  final Verify verify;

  ClassroomDetailBloc({
    required this.getClassroomDetail,
    required this.getUpcomingClass,
    required this.markAttendance,
    required this.verify,
  }) : super(StudentClassroomDetailInitial()) {
    on<ClassroomDetailFetched>(_onClassroomDetailFetched);
    on<UpcomingClassFetched>(_onUpcomingClassFetched);
    on<MarkAttendanceRequested>(_onMarkAttendanceRequested); // <--- Add this
  }

  Future<void> _onClassroomDetailFetched(
    ClassroomDetailFetched event,
    Emitter<StudentClassroomDetailState> emit,
  ) async {
    emit(ClassroomDetailLoading());

    final params = GetClassroomDetailUsecaseParams(
      token: event.token,
      classroomId: event.classroomId,
    );

    final result = await getClassroomDetail(params);

    result.fold(
      (failure) => emit(ClassroomDetailError(message: failure.message)),
      (classroomDetail) {
        emit(ClassroomDetailLoaded(classroom: classroomDetail));

        // After loading classroom details, fetch upcoming class
        add(UpcomingClassFetched(classroomId: event.classroomId));
      },
    );
  }

  Future<void> _onUpcomingClassFetched(
    UpcomingClassFetched event,
    Emitter<StudentClassroomDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is ClassroomDetailLoaded) {
      emit(ClassroomDetailLoaded(
        classroom: currentState.classroom,
        upcomingClassStatus: UpcomingClassStatus.loading,
      ));

      final params = GetUpcomingClassParams(
        classroomId: event.classroomId,
      );

      try {
        final result = await getUpcomingClass(params);

        result.fold(
          (failure) {
            // Always treat any failure as "no upcoming class" for a cleaner UI
            emit(ClassroomDetailLoaded(
              classroom: currentState.classroom,
              upcomingClassStatus: UpcomingClassStatus.noClass,
            ));
          },
          (upcomingClass) => emit(ClassroomDetailLoaded(
            classroom: currentState.classroom,
            upcomingClass: upcomingClass,
            upcomingClassStatus: UpcomingClassStatus.loaded,
          )),
        );
      } catch (e) {
        // Catch any unexpected exceptions and still show "no class" instead of error
        emit(ClassroomDetailLoaded(
          classroom: currentState.classroom,
          upcomingClassStatus: UpcomingClassStatus.noClass,
        ));
      }
    }
  }

  Future<void> _onMarkAttendanceRequested(
    MarkAttendanceRequested event,
    Emitter<StudentClassroomDetailState> emit,
  ) async {
    emit(AttendanceMarkingInProgress());

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

    int distance = distanceInMeters.round() * 1000;
    'Distance: $distance';

    final verifyResult = await verify(
      VerifyParams(distance: distance),
    );

    return verifyResult.fold(
      (failure) => emit(AttendanceMarkedFailure(error: failure.message)),
      (res) async {
        bool isVerified = res.result == "1";

        final now = DateTime.now().toIso8601String();

        final params = MarkAttendanceUsecase(
          classId: event.classId,
          studentToken: event.token,
          isPresent: isVerified,
        );
        final result = await markAttendance(params);

        result.fold(
          (failure) => emit(AttendanceMarkedFailure(error: failure.message)),
          (message) => emit(AttendanceMarkedSuccess(message: message)),
        );
      },
    );

    // final result = await markAttendance(params);

    // result.fold(
    //   (failure) => emit(AttendanceMarkedFailure(error: failure.message)),
    //   (message) => emit(AttendanceMarkedSuccess(message: message)),
    // );
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
