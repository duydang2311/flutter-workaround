part of 'create_work_bloc.dart';

final class CreateWorkState extends Equatable {
  const CreateWorkState({
    this.submission = const Submission(status: FormzSubmissionStatus.initial),
    this.title = const Title.pure(),
    this.description = const Description.pure(),
    this.isValid = false,
  });

  final Submission submission;
  final Title title;
  final Description description;
  final bool isValid;

  CreateWorkState copyWith({
    Submission? submission,
    Title? title,
    Description? description,
    bool? isValid,
  }) =>
      CreateWorkState(
        submission: submission ?? this.submission,
        title: title ?? this.title,
        description: description ?? this.description,
        isValid: isValid ?? this.isValid,
      );

  @override
  List<Object> get props => [submission, title, description, isValid];
}
