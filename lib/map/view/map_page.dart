import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_client/location_client.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/map/bloc/map_bloc.dart';

final class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (_) => MapBloc(
        textStyle: TextStyle(fontSize: 48, color: colorScheme.onInverseSurface),
        backgroundColor: colorScheme.inverseSurface,
        workRepository: RepositoryProvider.of<WorkRepository>(context),
        locationClient: RepositoryProvider.of<LocationClient>(context),
      )..add(const MapInitialized()),
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
    const initialCameraPosition = CameraPosition(
      target: LatLng(10.823099, 106.629662),
      zoom: 14.4746,
    );
    return ColoredBox(
      color: Theme.of(context).colorScheme.background,
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) => GoogleMap(
          cloudMapId: 'ebc5db417440cd29',
          initialCameraPosition: initialCameraPosition,
          zoomControlsEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          buildingsEnabled: false,
          trafficEnabled: false,
          liteModeEnabled: false,
          indoorViewEnabled: false,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          fortyFiveDegreeImageryEnabled: false,
          markers: state.markers,
          onMapCreated: (value) {
            context.read<MapBloc>().add(MapCreated(controller: value));
          },
        ),
      ),
    );
  }
}
