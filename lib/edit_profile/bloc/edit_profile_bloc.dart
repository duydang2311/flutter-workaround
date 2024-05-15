import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:workaround/edit_profile/models/models.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
       super(
            const EditProfileState(profile: Option.none(), name: Name.pure())) {
    on<EditProfileChanged>(_handleEditProfileChanged);
    on<EditProfileNameChange>(_onEditProfileNameChanged);
    on<EditProfileRefreshRequested>(_handleProfileRefreshRequested);

    _profileSubscription = profileRepository.profile.listen((profile) {
      add(EditProfileChanged(profile: profile));
    });
  }
  final ProfileRepository _profileRepository;
  late final StreamSubscription<Option<Profile>> _profileSubscription;
  
  Future<void> _handleProfileRefreshRequested(
        EditProfileRefreshRequested event, Emitter<EditProfileState> emit
  ) async { 
    final profile = await _profileRepository.fetchProfile();
    emit(state.copyWith(profile: profile, status: Status.ready)) ;
  }
  void _handleEditProfileChanged(
      EditProfileChanged event, Emitter<EditProfileState> emit) {
    emit(state.copyWith(profile: event.profile, status: Status.ready));
  }

  void _onEditProfileNameChanged(
      EditProfileNameChange event, Emitter<EditProfileState> emit) {
    final name = Name.dirty(event.name);

    emit(state.copyWith(
        name: name,
        isValid: Formz.validate([
          name,
        ])));
  }

  @override
  Future<void> close() {
    _profileSubscription.cancel();
    return super.close();
  }
}
