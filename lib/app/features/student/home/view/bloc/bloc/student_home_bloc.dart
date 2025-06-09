import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';
import 'package:zkp_app/app/features/student/home/domain/usecase/get_classroom_for_student.dart';
import 'package:zkp_app/app/features/student/home/domain/usecase/get_classrooms.dart';
import 'package:zkp_app/app/features/student/home/domain/usecase/join_classroom.dart';
import 'package:zkp_app/app/utils/use_case.dart';

part 'student_home_event.dart';
part 'student_home_state.dart';

class StudentHomeBloc extends Bloc<StudentHomeEvent, StudentHomeState> {
  final GetClassrooms getClassrooms;
  final GetClassroomForStudent getClassroomsForStudent;
  final JoinClassroom joinClassroom;

  StudentHomeBloc({
    required this.getClassrooms,
    required this.getClassroomsForStudent,
    required this.joinClassroom,
  }) : super(StudentHomeState.initial()) {
    on<FetchClassroomsEvent>(_onFetchClassrooms);
    on<ChangeFilterEvent>(_onChangeFilter);
    on<JoinClassroomEvent>(_onJoinClassroom);
  }

  Future<void> _onFetchClassrooms(
    FetchClassroomsEvent event,
    Emitter<StudentHomeState> emit,
  ) async {
    emit(state.copyWith(status: ClassroomStatus.loading));

    final result = state.filter == ClassroomFilter.all
        ? await getClassrooms(NoParams())
        : await getClassroomsForStudent(
            GetClassroomForStudentParams(token: event.token),
          );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ClassroomStatus.failure,
        errorMessage: failure.message,
      )),
      (classrooms) => emit(state.copyWith(
        status: ClassroomStatus.success,
        classrooms: classrooms,
      )),
    );
  }

  void _onChangeFilter(
    ChangeFilterEvent event,
    Emitter<StudentHomeState> emit,
  ) {
    if (event.filter != state.filter) {
      emit(state.copyWith(
        filter: event.filter,
        status: ClassroomStatus.loading,
      ));

      add(FetchClassroomsEvent(token: event.token));
    }
  }

  Future<void> _onJoinClassroom(
    JoinClassroomEvent event,
    Emitter<StudentHomeState> emit,
  ) async {
    emit(state.copyWith(
      joinStatus: JoinClassroomStatus.loading,
      joinMessage: null,
    ));

    final result = await joinClassroom(
      JoinClassroomUsecaseParams(
        token: event.token,
        classroomId: event.classroomId,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        joinStatus: JoinClassroomStatus.failure,
        joinMessage: failure.message,
      )),
      (message) => emit(state.copyWith(
        joinStatus: JoinClassroomStatus.success,
        joinMessage: message,
      )),
    );

    // Refresh the classroom list after join attempt (whether success or failure)
    add(FetchClassroomsEvent(token: event.token));
  }
}
