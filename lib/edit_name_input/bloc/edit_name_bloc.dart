import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workaround/edit_name_input/models/models.dart';
import 'package:workaround/sign_up/models/models.dart';

part 'edit_name_event.dart';
part 'edit_name_state.dart';

class EditNameBloc extends Bloc<EditNameEvent, EditNameState> {
  EditNameBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const EditNameState(name: Name.pure())) {
    on<EditNameChange>(_handleNameInputChanged);
    on<EditNameSubmitted>(_handleSubmitted);
  }

  final ProfileRepository _profileRepository;
  void _handleNameInputChanged(
    EditNameChange event,
    Emitter<EditNameState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate(
          [name],
        ),
      ),
    );
  }

  Future<void> _handleSubmitted(
    EditNameSubmitted event,
    Emitter<EditNameState> emit,
  ) async {
    emit(
      state.copyWith(
        submission: const Submission(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );
    
    try {
      await _profileRepository.updateDisplayName(state.name.value);
      emit(
        state.copyWith(
          submission: const Submission(status: FormzSubmissionStatus.success),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          submission: Submission(
              status: FormzSubmissionStatus.failure,
              error: _submissionError(error)),
        ),
      );
    }
  }

  SubmissionError _submissionError(dynamic error) {
  if (error is PostgrestException) {
    return SubmissionErrorUnknown(
      code: error.code.toString(),
      message: 'Failed to update display name: ${error.message}',
    );
  } else {
    return SubmissionErrorUnknown(
      code: 'UNKNOWN_ERROR',
      message: 'An unknown error occurred while updating the display name',
    );
  }
}

}
