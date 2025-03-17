// login_bloc.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/domain/entity/register_user_entity.dart';
import 'package:zkp_app/app/domain/usecases/login.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginInitialState()) {
    on<LoginSubmittedEvent>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());

    final result = await loginUseCase(LoginParams(token: event.token));

    result.fold(
      (failure) => emit(LoginFailureState(message: failure.message)),
      (user) => emit(LoginSuccessState(user: user)),
    );
  }
}
