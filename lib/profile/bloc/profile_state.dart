part of 'profile_bloc.dart';

final class ProfileState extends Equatable {
  const ProfileState({required this.profile, this.status = Status.loading});

  final Status status;
  final Option<Profile> profile;

  ProfileState copyWith({Option<Profile>? profile, Status? status}) =>
      ProfileState(
        profile: profile ?? this.profile,
        status: status ?? this.status,
      );

  @override
  List<Object> get props => [status, profile];
}
