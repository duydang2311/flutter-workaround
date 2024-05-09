import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:profile_repository/profile_repository.dart';

part 'img_picker_event.dart';
part 'img_picker_state.dart';

class ImgPickerBloc extends Bloc<ImgPickerEvent, ImgPickerState> {
  ImgPickerBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(ImgPickerState(file: null)) {
    on<ImgPickChange>(_handleImgPickerChanged);
    // on<EditDobInputSubmitted>(_handleSubmitted);
  
        }
        final ProfileRepository _profileRepository;

      void _handleImgPickerChanged(
         ImgPickChange event,
    Emitter<ImgPickerState> emit,
      ) {
        final file = (event.file);
    emit(
      state.copyWith(
        file: file,
        // isValid: Formz.validate(
        //   [dob],
        ),
      );
    // );
      }
}
