import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:location_client/location_client.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:workaround/create_work/create_work.dart';
import 'package:workaround/dart_define.gen.dart';

part 'bottom_sheet_event.dart';
part 'bottom_sheet_state.dart';

class BottomSheetBloc extends Bloc<BottomSheetEvent, BottomSheetState> {
  BottomSheetBloc(Client client, LocationClient locationClient)
      : _client = client,
        _locationClient = locationClient,
        _suggestionStreamController = StreamController(),
        super(
          const BottomSheetState(
            address: Address.pure(),
            suggestions: [],
            pending: false,
            selected: Option.none(),
            selectedTimestamp: 0,
          ),
        ) {
    on<BottomSheetAddressChanged>(_handleAddressChanged);
    on<BottomSheetSuggestionsChanged>(_handleSuggestionsChanged);
    on<BottomSheetPendingChanged>(_handlePendingChanged);
    on<BottomSheetLocationSelected>(_handleLocationSelected);
    _suggestionStreamSubscription = _suggestionStreamController.stream
        .debounce(const Duration(milliseconds: 500))
        .listen(_handleAddressSuggestion);
  }

  @override
  Future<void> close() async {
    await _suggestionStreamSubscription.cancel();
    await _suggestionStreamController.close();
    return super.close();
  }

  final StreamController<String> _suggestionStreamController;
  final Client _client;
  final LocationClient _locationClient;
  late final StreamSubscription<String> _suggestionStreamSubscription;

  Future<void> _handleAddressChanged(
    BottomSheetAddressChanged event,
    Emitter<BottomSheetState> emit,
  ) async {
    emit(state.copyWith(address: Address.dirty(event.address), pending: true));
    if (_suggestionStreamController.hasListener) {
      _suggestionStreamController.add(event.address);
    }
  }

  Future<void> _handleAddressSuggestion(
    String address,
  ) async {
    add(
      BottomSheetSuggestionsChanged(
        suggestions: await _locationClient
            .getCurrentPosition()
            .match<String?>((l) => null, (r) => '${r.latitude},${r.longitude}')
            .toTaskEither<GenericError>()
            .flatMap(
              (r) => TaskEither.tryCatch(
                () => _client.get(
                  Uri.https(
                    'rsapi.goong.io',
                    '/Place/AutoComplete',
                    {
                      'api_key': DartDefine.goongApiKey,
                      if (r != null) 'location': r,
                      'input': address,
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
                json['predictions'] as List?,
                () => const GenericError(
                  message: 'Could not fetch suggestions.',
                ),
              ),
            )
            .map(
              (e) => e
                  .map((e) => Suggestion.fromMap(e as Map<String, dynamic>))
                  .toList(),
            )
            .getOrElse((error) {
          log(error.toString());
          return <Suggestion>[];
        }).run(),
      ),
    );
  }

  void _handleSuggestionsChanged(
    BottomSheetSuggestionsChanged event,
    Emitter<BottomSheetState> emit,
  ) {
    emit(state.copyWith(suggestions: event.suggestions, pending: false));
  }

  void _handlePendingChanged(
    BottomSheetPendingChanged event,
    Emitter<BottomSheetState> emit,
  ) {
    emit(state.copyWith(pending: event.pending));
  }

  void _handleLocationSelected(
    BottomSheetLocationSelected event,
    Emitter<BottomSheetState> emit,
  ) {
    emit(
      state.copyWith(
        selected: event.index == -1
            ? const Option.none()
            : Option.of(state.suggestions[event.index]),
        selectedTimestamp:
            event.index == -1 ? DateTime.now().millisecondsSinceEpoch : null,
      ),
    );
  }
}
