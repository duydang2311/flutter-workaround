part of 'create_work_bloc.dart';

final class CreateWorkState extends Equatable {
  const CreateWorkState({
    this.submission = const Submission(status: FormzSubmissionStatus.initial),
    this.title = const Title.pure(),
    this.description = const Description.pure(),
    this.isValid = false,
    this.place = const Option.none(),
  });

  final Submission submission;
  final Title title;
  final Description description;
  final bool isValid;
  final Option<Place> place;

  CreateWorkState copyWith({
    Submission? submission,
    Title? title,
    Description? description,
    bool? isValid,
    Option<Place>? place,
  }) =>
      CreateWorkState(
        submission: submission ?? this.submission,
        title: title ?? this.title,
        description: description ?? this.description,
        isValid: isValid ?? this.isValid,
        place: place ?? this.place,
      );

  @override
  List<Object?> get props => [submission, title, description, isValid, place];
}
