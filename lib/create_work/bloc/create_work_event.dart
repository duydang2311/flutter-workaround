part of 'create_work_bloc.dart';

sealed class CreateWorkEvent extends Equatable {
  const CreateWorkEvent();

  @override
  List<Object> get props => [];
}

final class CreateWorkTitleChanged extends CreateWorkEvent {
  const CreateWorkTitleChanged({required this.title});

  final String title;

  @override
  List<Object> get props => [title];
}

final class CreateWorkDescriptionChanged extends CreateWorkEvent {
  const CreateWorkDescriptionChanged({required this.description});

  final String description;

  @override
  List<Object> get props => [description];
}

final class CreateWorkSubmitted extends CreateWorkEvent {
  const CreateWorkSubmitted();
}
