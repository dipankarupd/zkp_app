import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/features/admin/home/domain/usecases/create_classroom.dart';
import 'package:zkp_app/app/features/student/home/domain/entity/classroom_entity.dart';
import 'package:zkp_app/app/features/student/home/domain/usecase/get_classrooms.dart';

import 'package:zkp_app/app/utils/use_case.dart';

part 'admin_home_event.dart';
part 'admin_home_state.dart';

class AdminHomeBloc extends Bloc<AdminHomeEvent, AdminHomeState> {
  final GetClassrooms getClassrooms;
  final CreateClassroom createClass;

  AdminHomeBloc({
    required this.getClassrooms,
    required this.createClass,
  }) : super(AdminHomeState.initial()) {
    on<FetchClassroomsEvent>(_onFetchClassrooms);
    on<CreateClassroomEvent>(_onCreateClassroom);
  }

  Future<void> _onFetchClassrooms(
    FetchClassroomsEvent event,
    Emitter<AdminHomeState> emit,
  ) async {
    emit(state.copyWith(status: ClassroomStatus.loading));

    final result = await getClassrooms(NoParams());

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

  Future<void> _onCreateClassroom(
    CreateClassroomEvent event,
    Emitter<AdminHomeState> emit,
  ) async {
    emit(state.copyWith(addStatus: AddClassroomStatus.loading));

    final result = await createClass(
      CreateClassParams(
        name: event.name,
        description: event.description,
        teachername: event.teacherName,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        addStatus: AddClassroomStatus.failure,
        addMessage: failure.message,
      )),
      (success) {
        emit(state.copyWith(
          addStatus: AddClassroomStatus.success,
          addMessage: 'Classroom created successfully',
        ));

        // Refresh classrooms list after successful creation
        add(FetchClassroomsEvent(token: 'admin'));
      },
    );
  }
}
