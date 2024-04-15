import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc()
      : super(
          const MapState(
            controller: null,
            initialCameraPosition: CameraPosition(
              target: LatLng(10.823099, 106.629662),
              zoom: 14.4746,
            ),
          ),
        ) {
    on<MapCreated>(_handleMapCreated);
  }

  void _handleMapCreated(MapCreated event, Emitter<MapState> emit) {
    emit(state.copyWith(controller: event.controller));
  }
}
