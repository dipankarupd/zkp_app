import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:zkp_app/app/features/student/auth/domain/usecase/register.dart';

part 'bloc_event.dart';
part 'bloc_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final Register registerUsecase;
  RegistrationBloc(this.registerUsecase) : super(RegistrationState.initial()) {
    on<UserNameChangedEvent>((event, emit) {
      emit(state.copyWith(
        username: event.username,
      ));
    });

    on<LocationSelectedEvent>((event, emit) {
      emit(state.copyWith(
        latitude: event.latitude,
        longitude: event.longitude,
      ));
    });

    on<RegistrationSubmittedEvent>((event, emit) async {
      if (state.username.isEmpty ||
          state.latitude == null ||
          state.longitude == null) {
        emit(state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: 'Please enter all the values',
        ));
        return;
      }
      emit(state.copyWith(status: RegistrationStatus.loading));

      try {
        final res = await registerUsecase.call(
          RegisterParams(
            username: state.username,
            latitude: state.latitude!,
            longitude: state.longitude!,
          ),
        );

        res.fold((l) {
          print('Error: ${l.message.toString()}');
          emit(state.copyWith(
            status: RegistrationStatus.failure,

            errorMessage: l.message, // Assuming Failure has a message
          ));
        }, (r) {
          print('Token: ${r.token}');
          emit(state.copyWith(
            status: RegistrationStatus.success,
            token: r.token, // Integer token
          ));
        });
      } catch (a) {}
    });
  }
}
