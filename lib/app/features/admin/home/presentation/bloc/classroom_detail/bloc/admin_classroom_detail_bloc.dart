import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zkp_app/app/features/admin/home/domain/entity/classroom_detail_entity.dart';
import 'package:zkp_app/app/features/admin/home/domain/usecases/create_class.dart';
import 'package:zkp_app/app/features/admin/home/domain/usecases/get_classroom_detail.dart';

part 'admin_classroom_detail_event.dart';
part 'admin_classroom_detail_state.dart';

class AdminClassroomDetailBloc
    extends Bloc<AdminClassroomDetailEvent, AdminClassroomDetailState> {
  final GetClassroomDetailAdmin getClassroomDetail;
  final CreateClass createClass;

  AdminClassroomDetailBloc({
    required this.getClassroomDetail,
    required this.createClass,
  }) : super(AdminClassroomDetailState.initial()) {
    on<FetchClassroomDetailEvent>(_onFetchClassroomDetail);
    on<CreateClassEvent>(_onCreateClass);
    on<ClearErrorMessageEvent>(_onClearErrorMessage);
  }

  Future<void> _onFetchClassroomDetail(
    FetchClassroomDetailEvent event,
    Emitter<AdminClassroomDetailState> emit,
  ) async {
    emit(state.copyWith(
      status: ClassroomDetailStatus.loading,
      errorMessage: null, // Clear any previous errors
    ));

    final result = await getClassroomDetail(
      GetClassroomDetailParams(classroomId: event.classroomId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ClassroomDetailStatus.failure,
        errorMessage: failure.message,
      )),
      (classroomDetail) => emit(state.copyWith(
        status: ClassroomDetailStatus.success,
        classroomDetail: classroomDetail,
        errorMessage: null, // Ensure no error message on success
      )),
    );
  }

  Future<void> _onCreateClass(
    CreateClassEvent event,
    Emitter<AdminClassroomDetailState> emit,
  ) async {
    // Start with loading state but preserve classroom data
    emit(state.copyWith(
      status: ClassroomDetailStatus.loading,
      errorMessage: null, // Clear any previous errors
    ));

    final result = await createClass(
      CreateClassParams(
        startTime: event.startTime,
        endTime: event.endTime,
        meetLink: event.meetLink,
        classroomId: event.classroomId,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status:
              ClassroomDetailStatus.success, // Keep success state to show data
          errorMessage: failure.message,
        ));
      },
      (message) {
        // On success, set a success message then refetch
        emit(state.copyWith(
          status: ClassroomDetailStatus.success,
          errorMessage: null,
          successMessage: "Class created successfully", // Add success message
        ));

        // After successful creation, refetch the classroom detail
        add(FetchClassroomDetailEvent(classroomId: event.classroomId));
      },
    );
  }

  void _onClearErrorMessage(
    ClearErrorMessageEvent event,
    Emitter<AdminClassroomDetailState> emit,
  ) {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}
