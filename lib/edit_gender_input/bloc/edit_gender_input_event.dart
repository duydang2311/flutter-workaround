part of 'edit_gender_input_bloc.dart';

sealed class EditGenderInputEvent extends Equatable {
  const EditGenderInputEvent();

  @override
  List<Object> get props => [];
}


final class EditGenderInputChange extends  EditGenderInputEvent{
  const EditGenderInputChange(this.gender);
  final String gender;

  @override
  List<Object> get props => [gender];
}

final class EditGenderInputSubmitted extends EditGenderInputEvent {
  const EditGenderInputSubmitted();
}