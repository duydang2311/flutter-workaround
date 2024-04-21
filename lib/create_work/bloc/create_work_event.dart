part of 'create_work_bloc.dart';

sealed class CreateWorkEvent extends Equatable {
  const CreateWorkEvent();

  @override
  List<Object> get props => [];
}

final class CreateWorkInitialized extends CreateWorkEvent {
  const CreateWorkInitialized();
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

final class CreateWorkLocationChanged extends CreateWorkEvent {
  const CreateWorkLocationChanged({
    required this.position,
    required this.address,
  });

  final Position position;
  final String address;

  @override
  List<Object> get props => [position, address];
}

final class CreateWorkSubmitted extends CreateWorkEvent {
  const CreateWorkSubmitted();
}
