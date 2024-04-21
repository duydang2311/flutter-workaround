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
    required this.lat,
    required this.lng,
    required this.address,
  });

  final double lat;
  final double lng;
  final String address;

  @override
  List<Object> get props => [lat, lng, address];
}

final class CreateWorkSuggestionSelected extends CreateWorkEvent {
  const CreateWorkSuggestionSelected({required this.suggestion});

  final Option<Suggestion> suggestion;

  @override
  List<Object> get props => [suggestion];
}

final class CreateWorkSubmitted extends CreateWorkEvent {
  const CreateWorkSubmitted();
}
