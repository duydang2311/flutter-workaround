part of 'edit_name_bloc.dart';

final class EditNameState extends Equatable {
  const EditNameState({
    required this.name,
    this.status = Status.loading,
    this.isValid = false,
    this.submission = const Submission(status: FormzSubmissionStatus.initial),
  });

  final Submission submission;
  final Status status;
  final Name name;
  final bool isValid;

  EditNameState copyWith({
    Status? status,
    Name? name,
    bool? isValid,
    Submission? submission,
  }) =>
      EditNameState(
        status: status ?? this.status,
        name: name ?? this.name,
        isValid: isValid ?? this.isValid,
        submission: submission ?? this.submission,
      );
  @override
  List<Object> get props => [submission,status, isValid, name];
}
