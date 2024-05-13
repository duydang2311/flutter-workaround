part of 'img_picker_bloc.dart';

final class ImgPickerState extends Equatable {
  
  const ImgPickerState({
    required this.file,
    this.status = Status.loading,
    this.isValid = false,
    this.submission = const SubmissionUpdateAvata(status: FormzSubmissionStatus.initial),
  });
  
  final SubmissionUpdateAvata submission;
  final Status status;
  final bool isValid;
  final File? file;

  ImgPickerState copyWith({
    File? file, 
     Status? status,
    bool? isValid,
    SubmissionUpdateAvata? submission,
  }) =>
      ImgPickerState(
        file: file ?? this.file,
        status: status ?? this.status,
        isValid: isValid ?? this.isValid,
        submission: submission ?? this.submission,
      );
  @override
  List<Object?> get props => [file, submission,status, isValid];
}

