import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workaround/edit_dob_input/models/models.dart';
import 'package:workaround/sign_up/models/models.dart';

part 'edit_dob_input_event.dart';
part 'edit_dob_input_state.dart';

class EditDobInputBloc extends Bloc<EditDobInputEvent, EditDobInputState> {
  EditDobInputBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(EditDobInputState(dob: Dob.pure())) {
    on<EditDobInputChange>(_handleNameInputChanged);
    on<EditDobInputSubmitted>(_handleSubmitted);
  }

  final ProfileRepository _profileRepository;
  void _handleNameInputChanged(
    EditDobInputChange event,
    Emitter<EditDobInputState> emit,
  ) {
    final dob = Dob.dirty(event.dob);
    emit(
      state.copyWith(
        dob: dob,
        isValid: Formz.validate(
          [dob],
        ),
      ),
    );
  }

  Future<void> _handleSubmitted(
    EditDobInputSubmitted event,
    Emitter<EditDobInputState> emit,
  ) async {
    try {
      print(state.dob.value);
      await _profileRepository.updateDob(state.dob.value);
      emit(
        state.copyWith(
          submission: const Submission(status: FormzSubmissionStatus.success),
        ),
      );
    } catch (error) {
      print(error);
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
