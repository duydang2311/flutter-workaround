part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}



final class EditProfileChanged extends EditProfileEvent {
  const EditProfileChanged({required this.profile});

  final Option<Profile> profile;

  @override
  List<Object> get props => [profile];
}


final class EditProfileNameChange extends EditProfileEvent {
  const EditProfileNameChange(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}
