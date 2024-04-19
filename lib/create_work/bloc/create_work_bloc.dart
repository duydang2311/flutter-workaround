import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/create_work/create_work.dart';

part 'create_work_event.dart';
part 'create_work_state.dart';

class CreateWorkBloc extends Bloc<CreateWorkEvent, CreateWorkState> {
  CreateWorkBloc(
      {required AppUserRepository appUserRepository,
      required WorkRepository workRepository})
      : _workRepository = workRepository,
        _appUserRepository = appUserRepository,
        super(const CreateWorkState()) {
    on<CreateWorkTitleChanged>(_handleTitleChanged);
    on<CreateWorkDescriptionChanged>(_handleDescriptionChanged);
    on<CreateWorkSubmitted>(_handleSubmitted);
  }

  final WorkRepository _workRepository;
  final AppUserRepository _appUserRepository;

  void _handleTitleChanged(
    CreateWorkTitleChanged event,
    Emitter<CreateWorkState> emit,
  ) {
    final title = Title.dirty(event.title);
    emit(
      state.copyWith(
        title: title,
        isValid: Formz.validate(
          [
            title,
            state.description,
          ],
        ),
      ),
    );
  }

  void _handleDescriptionChanged(
    CreateWorkDescriptionChanged event,
    Emitter<CreateWorkState> emit,
  ) {
    emit(state.copyWith(description: Description.dirty(event.description)));
  }

  Future<void> _handleSubmitted(
    CreateWorkSubmitted event,
    Emitter<CreateWorkState> emit,
  ) async {
    emit(
      state.copyWith(
        submission: const Submission(status: FormzSubmissionStatus.inProgress),
      ),
    );

    emit(
      state.copyWith(
        submission: await _workRepository
            .insertWork(
              Work(
                ownerId: _appUserRepository.currentUser.match(
                  () => '',
                  (appUser) => appUser.id,
                ),
                title: state.title.value,
                description: state.description.value.isEmpty
                    ? null
                    : state.description.value,
              ),
            )
            .match(
              (error) => Submission(
                status: FormzSubmissionStatus.failure,
                errorMessage: _saveWorkErrorMessage(error),
              ),
              (_) => const Submission(status: FormzSubmissionStatus.success),
            )
            .run(),
      ),
    );
  }

  String _saveWorkErrorMessage(SaveWorkError error) {
    switch (error.code) {
      default:
        return error.message;
    }
  }
}
