part of 'edit_profile_bloc.dart';

final class EditProfileState extends Equatable {
  const EditProfileState({
    required this.profile,
    required this.name,
    this.status = Status.loading,
    this.isValid = false,
  });

  final Status status;
  final Option<Profile> profile;
  final Name name;
  final bool isValid;

  EditProfileState copyWith({
    Option<Profile>? profile,
    Status? status,
    Name? name,
    bool? isValid,
  }) =>
      EditProfileState(
        profile: profile ?? this.profile,
        status: status ?? this.status,
        name: name ?? this.name,
        isValid: isValid ?? this.isValid,
      );
  @override
  List<Object> get props => [status, profile, isValid, name];
}
