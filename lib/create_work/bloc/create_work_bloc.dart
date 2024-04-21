import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:user_repository/user_repository.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/create_work/create_work.dart';
import 'package:workaround/dart_define.gen.dart';

part 'create_work_event.dart';
part 'create_work_state.dart';

class CreateWorkBloc extends Bloc<CreateWorkEvent, CreateWorkState> {
  CreateWorkBloc({
    required Client client,
    required AppUserRepository appUserRepository,
    required WorkRepository workRepository,
  })  : _client = client,
        _workRepository = workRepository,
        _appUserRepository = appUserRepository,
        super(const CreateWorkState()) {
    on<CreateWorkInitialized>(_handleInitialized);
    on<CreateWorkTitleChanged>(_handleTitleChanged);
    on<CreateWorkDescriptionChanged>(_handleDescriptionChanged);
    on<CreateWorkSuggestionSelected>(_handleSuggestionSelected);
    on<CreateWorkSubmitted>(_handleSubmitted);
  }

  final Client _client;
  final WorkRepository _workRepository;
  final AppUserRepository _appUserRepository;

  Future<void> _handleInitialized(
    CreateWorkInitialized event,
    Emitter<CreateWorkState> emit,
  ) async {
    if (!await TaskOption.tryCatch(Geolocator.isLocationServiceEnabled)
        .getOrElse(() => false)
        .run()) {
      return;
    }

    await TaskOption.tryCatch(Geolocator.checkPermission)
        .flatMap(
          (permission) => permission == LocationPermission.denied
              ? TaskOption.tryCatch(Geolocator.requestPermission)
              : TaskOption<LocationPermission>.none(),
        )
        .run();
  }

  void _handleTitleChanged(
    CreateWorkTitleChanged event,
    Emitter<CreateWorkState> emit,
  ) {
    final title = Title.dirty(event.title);
    emit(
      state.copyWith(
        title: title,
        isValid: Formz.validate(
          [
            title,
            state.description,
          ],
        ),
      ),
    );
  }

  void _handleDescriptionChanged(
    CreateWorkDescriptionChanged event,
    Emitter<CreateWorkState> emit,
  ) {
    emit(state.copyWith(description: Description.dirty(event.description)));
  }

  Future<void> _handleSuggestionSelected(
    CreateWorkSuggestionSelected event,
    Emitter<CreateWorkState> emit,
  ) async {
    emit(
      state.copyWith(
        place: await event.suggestion
            .match(
              () => TaskOption.tryCatch(
                () => Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high,
                ),
              )
                  .flatMap(
                    (position) => TaskOption.tryCatch(
                      () => _client.get(
                        Uri.https(
                          'rsapi.goong.io',
                          '/Geocode',
                          {
                            'latlng':
                                '${position.latitude}, ${position.longitude}',
                            'api_key': DartDefine.goongApiKey,
                          },
                        ),
                      ),
                    ),
                  )
                  .map(
                    (response) => jsonDecode(utf8.decode(response.bodyBytes))
                        as Map<String, dynamic>,
                  )
                  .flatMap(
                    (json) => TaskOption.fromNullable(
                      (json['results'] as List?)?.first
                          as Map<String, dynamic>?,
                    ),
                  )
                  .map(Place.fromJson),
              (suggestion) => TaskOption.tryCatch(
                () => _client.get(
                  Uri.https(
                    'rsapi.goong.io',
                    '/Place/Detail',
                    {
                      'place_id': suggestion.placeId,
                      'api_key': DartDefine.goongApiKey,
                    },
                  ),
                ),
              )
                  .map(
                    (r) => jsonDecode(utf8.decode(r.bodyBytes))
                        as Map<String, dynamic>,
                  )
                  .flatMap(
                    (json) => TaskOption.fromNullable(
                      json['result'] as Map<String, dynamic>?,
                    ),
                  )
                  .map(Place.fromJson),
            )
            .orElse<Place>(
              () => TaskOption.of(
                const Place(
                  id: '',
                  lat: 0,
                  lng: 0,
                  address: '',
                  errorMessage: Option.of('Could not retrieve your address'),
                ),
              ),
            )
            .run(),
      ),
    );
  }

  Future<void> _handleSubmitted(
    CreateWorkSubmitted event,
    Emitter<CreateWorkState> emit,
  ) async {
    emit(
      state.copyWith(
        submission: const Submission(status: FormzSubmissionStatus.inProgress),
      ),
    );

    final place = state.place.toNullable()!;
    emit(
      state.copyWith(
        submission: await _workRepository
            .insertWork(
              Work(
                ownerId: _appUserRepository.currentUser.match(
                  () => '',
                  (appUser) => appUser.id,
                ),
                title: state.title.value,
                description: state.description.value.isEmpty
                    ? null
                    : state.description.value,
                placeId: place.id,
                lat: place.lat,
                lng: place.lng,
              ),
            )
            .match(
              (error) => Submission(
                status: FormzSubmissionStatus.failure,
                errorMessage: _saveWorkErrorMessage(error),
              ),
              (_) => const Submission(status: FormzSubmissionStatus.success),
            )
            .run(),
      ),
    );
  }

  String _saveWorkErrorMessage(SaveWorkError error) {
    switch (error.code) {
      default:
        return error.message;
    }
  }
}
