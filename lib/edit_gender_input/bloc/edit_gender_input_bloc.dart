import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workaround/edit_gender_input/models/models.dart';
import 'package:workaround/sign_up/models/models.dart';

part 'edit_gender_input_event.dart';
part 'edit_gender_input_state.dart';

class EditGenderInputBloc extends Bloc<EditGenderInputEvent, EditGenderInputState> {
  EditGenderInputBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const EditGenderInputState(gender: Gender.pure())) {
    on<EditGenderInputChange>(_handleGenderInputChanged);
    on<EditGenderInputSubmitted>(_handleSubmitted);
  }

  final ProfileRepository _profileRepository;
  void _handleGenderInputChanged(
    EditGenderInputChange event,
    Emitter<EditGenderInputState> emit,
  ) {
    final gender = Gender.dirty(event.gender);
    emit(
      state.copyWith(
        gender: gender,
        isValid: Formz.validate(
          [gender],
        ),
      ),
    );
  }

  Future<void> _handleSubmitted(
    EditGenderInputSubmitted event,
    Emitter<EditGenderInputState> emit,
  ) async {
    try {
      await _profileRepository.updateGender(state.gender.value);
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
