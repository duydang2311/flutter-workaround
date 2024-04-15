import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workaround/map/bloc/map_bloc.dart';

final class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(),
      child: const SafeArea(
        child: _MapView(),
      ),
    );
  }
}

final class _MapView extends StatelessWidget {
  const _MapView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) => GoogleMap(
        initialCameraPosition: state.initialCameraPosition,
        zoomControlsEnabled: false,
        compassEnabled: false,
        mapToolbarEnabled: false,
        onMapCreated: (value) {
          context.read<MapBloc>().add(MapCreated(controller: value));
        },
      ),
    );
  }
}
