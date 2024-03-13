import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:workaround/profile/models/models.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required ProfileRepository profileRepository})
      : super(const ProfileState(profile: Option.none())) {
    on<ProfileChanged>(_handleProfileChanged);

    _profileSubscription = profileRepository.profile.listen((profile) {
      add(ProfileChanged(profile: profile));
    });
  }

  late final StreamSubscription<Option<Profile>> _profileSubscription;

  void _handleProfileChanged(ProfileChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(profile: event.profile, status: Status.ready));
  }

  @override
  Future<void> close() {
    _profileSubscription.cancel();
    return super.close();
  }
}
