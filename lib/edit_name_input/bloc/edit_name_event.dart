part of 'edit_name_bloc.dart';

sealed class EditNameEvent extends Equatable {
  const EditNameEvent();

  @override
  List<Object> get props => [];
}

final class EditNameChange extends  EditNameEvent{
  const EditNameChange(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}

final class EditNameSubmitted extends EditNameEvent {
  const EditNameSubmitted();
}