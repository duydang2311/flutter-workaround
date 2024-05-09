part of 'edit_gender_input_bloc.dart';

final class EditGenderInputState extends Equatable {
 const EditGenderInputState({
    required this.gender,
    this.status = Status.loading,
    this.isValid = false,
    this.submission = const Submission(status: FormzSubmissionStatus.initial),
  });

  final Submission submission;
  final Status status;
  final Gender gender;
  final bool isValid;

  EditGenderInputState copyWith({
    Status? status,
    Gender? gender,
    bool? isValid,
    Submission? submission,
  }) =>
      EditGenderInputState(
        status: status ?? this.status,
        gender: gender ?? this.gender,
        isValid: isValid ?? this.isValid,
        submission: submission ?? this.submission,
      );
  @override
  List<Object> get props => [submission,status, isValid, gender];
}


