import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:location_client/location_client.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:user_repository/user_repository.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/create_work/create_work.dart';
import 'package:workaround/dart_define.gen.dart';

part 'create_work_event.dart';
part 'create_work_state.dart';

class CreateWorkBloc extends Bloc<CreateWorkEvent, CreateWorkState> {
  CreateWorkBloc({
    required Client client,
    required LocationClient locationClient,
    required AppUserRepository appUserRepository,
    required WorkRepository workRepository,
  })  : _client = client,
        _locationClient = locationClient,
        _workRepository = workRepository,
        _appUserRepository = appUserRepository,
        super(const CreateWorkState()) {
    on<CreateWorkTitleChanged>(_handleTitleChanged);
    on<CreateWorkDescriptionChanged>(_handleDescriptionChanged);
    on<CreateWorkSuggestionSelected>(_handleSuggestionSelected);
    on<CreateWorkSubmitted>(_handleSubmitted);
  }

  final Client _client;
  final LocationClient _locationClient;
  final WorkRepository _workRepository;
  final AppUserRepository _appUserRepository;

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
    final place = Option.fromEither(
      await event.suggestion
          .match(
            () => _locationClient
                .checkPermission()
                .toTaskEither<GenericError>()
                .flatMap<LocationPermission>(
                  (r) => switch (r) {
                    LocationPermission.denied =>
                      _locationClient.requestPermission(),
                    LocationPermission.deniedForever =>
                      TaskEither.left(GenericError(
                        message: 'Location permission has been denied forever.',
                      )),
                    LocationPermission.always ||
                    LocationPermission.whileInUse =>
                      TaskEither.right(r),
                    _ => TaskEither.left(const GenericError.unknown()),
                  },
                )
                .flatMap<Position>(
                  (r) => switch (r) {
                    LocationPermission.always ||
                    LocationPermission.whileInUse =>
                      _locationClient.getCurrentPosition(),
                    _ => TaskEither.left(
                        const GenericError(
                          message: 'Could not get device location.',
                        ),
                      ),
                  },
                )
                .flatMap(
                  (position) => TaskEither.tryCatch(
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
                    (error, _) => switch (error) {
                      final Exception e => GenericError.fromException(e),
                      _ => const GenericError.unknown(),
                    },
                  ),
                )
                .map(
                  (response) => jsonDecode(utf8.decode(response.bodyBytes))
                      as Map<String, dynamic>,
                )
                .flatMap(
                  (json) => TaskEither.fromNullable(
                    (json['results'] as List?)?.first as Map<String, dynamic>?,
                    () => const GenericError(
                      message: 'Could not convert JSON.',
                    ),
                  ),
                )
                .map(Place.fromJson),
            (suggestion) => TaskEither.tryCatch(
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
                    (error, _) => switch (error) {
                          final Exception e => GenericError.fromException(e),
                          _ => const GenericError.unknown(),
                        })
                .map(
                  (r) => jsonDecode(utf8.decode(r.bodyBytes))
                      as Map<String, dynamic>,
                )
                .flatMap(
                  (json) => TaskEither.fromNullable(
                    json['result'] as Map<String, dynamic>?,
                    () => const GenericError(
                      message: 'Could not convert response.',
                    ),
                  ),
                )
                .map(Place.fromJson),
          )
          .orElse<GenericError>(
            (error) => TaskEither.right(
              Place(
                id: '',
                lat: 0,
                lng: 0,
                address: '',
                errorMessage: Option.of(error.message),
              ),
            ),
          )
          .run(),
    );
    emit(
      state.copyWith(
        place: place,
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
