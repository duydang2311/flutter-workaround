part of 'edit_dob_input_bloc.dart';

sealed class EditDobInputEvent extends Equatable {
  const EditDobInputEvent();

  @override
  List<Object> get props => [];
}



final class EditDobInputChange extends  EditDobInputEvent{
  const EditDobInputChange(this.dob);
  final DateTime dob;

  @override
  List<Object> get props => [dob];
}

final class EditDobInputSubmitted extends EditDobInputEvent {
  const EditDobInputSubmitted();
}