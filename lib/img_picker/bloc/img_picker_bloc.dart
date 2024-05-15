import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workaround/img_picker/models/models.dart';
import 'package:workaround/sign_up/models/models.dart';

part 'img_picker_event.dart';
part 'img_picker_state.dart';

class ImgPickerBloc extends Bloc<ImgPickerEvent, ImgPickerState> {
  ImgPickerBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const ImgPickerState(file: null)) {
    on<ImgPickChange>(_handleImgPickerChanged);
    on<ImgPickerSubmitted>(_handleSubmitted);
  
        }
        final ProfileRepository _profileRepository;

      void _handleImgPickerChanged(
         ImgPickChange event,
    Emitter<ImgPickerState> emit,
      ) {
        final file = event.file;
        final isValid = file != null;

    emit(
      state.copyWith(
        file: file,
        isValid: isValid,
        ),
      );
    }

  Future<void> _handleSubmitted(
    ImgPickerSubmitted event,
    Emitter<ImgPickerState> emit,
  ) async {
    try {
      await _profileRepository.updateAvata(state.file!);
      emit(
        state.copyWith(
          submission: const SubmissionUpdateAvata(status: FormzSubmissionStatus.success),
        ),
      );
    } catch (error) {
      print(error);
      emit(
        state.copyWith(
          submission: SubmissionUpdateAvata(
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
        message: 'Failed to update avata user: ${error.message}',
      );
    } else {
      return SubmissionErrorUnknown(
        code: 'UNKNOWN_ERROR',
        message: 'An unknown error occurred while updating the avata user',
      );
    }
  }
}
