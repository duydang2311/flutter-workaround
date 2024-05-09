part of 'edit_dob_input_bloc.dart';

final class EditDobInputState extends Equatable {
  const EditDobInputState({
    required this.dob,
    this.status = Status.loading,
    this.isValid = false,
    this.submission = const Submission(status: FormzSubmissionStatus.initial),
  });

  final Submission submission;
  final Status status;
  final Dob dob;
  final bool isValid;

  EditDobInputState copyWith({
    Status? status,
    Dob? dob,
    bool? isValid,
    Submission? submission,
  }) =>
      EditDobInputState(
        status: status ?? this.status,
        dob: dob ?? this.dob,
        isValid: isValid ?? this.isValid,
        submission: submission ?? this.submission,
      );
  @override
  List<Object> get props => [submission,status, isValid, dob];
}

