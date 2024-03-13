part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class ProfileChanged extends ProfileEvent {
  const ProfileChanged({required this.profile});

  final Option<Profile> profile;

  @override
  List<Object> get props => [profile];
}
