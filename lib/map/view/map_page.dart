import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_client/location_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/dart_define.gen.dart';
import 'package:workaround/map/bloc/map_bloc.dart';

final class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapBloc(
        workRepository: RepositoryProvider.of<WorkRepository>(context),
        locationClient: RepositoryProvider.of<LocationClient>(context),
      )..add(const MapInitialized()),
      child: const SafeArea(
        child: _MapView(),
      ),
    );
  }
}

// final class _MapView extends StatelessWidget {
//   const _MapView();

//   @override
//   Widget build(BuildContext context) {
//     const initialCameraPosition = CameraPosition(
//       target: LatLng(10.823099, 106.629662),
//       zoom: 14.4746,
//     );
//     return ColoredBox(
//       color: Theme.of(context).colorScheme.background,
//       child: BlocBuilder<MapBloc, MapState>(
//         builder: (context, state) => GoogleMap(
//           cloudMapId: 'ebc5db417440cd29',
//           initialCameraPosition: initialCameraPosition,
//           zoomControlsEnabled: false,
//           compassEnabled: false,
//           mapToolbarEnabled: false,
//           buildingsEnabled: false,
//           myLocationButtonEnabled: false,
//           markers: Set.from(
//             state.mapWorks.map(
//               (e) => Marker(
//                 markerId: MarkerId(e.work.id),
//                 icon: e.icon,
//                 position: LatLng(e.work.lat, e.work.lng),
//                 infoWindow: e.details.match(
//                   () => InfoWindow.noText,
//                   (details) => InfoWindow(
//                     title: details.title,
//                     snippet: details.description,
//                   ),
//                 ),
//                 onTap: () {
//                   context.read<MapBloc>().add(MapWorkTapped(e));
//                 },
//               ),
//             ),
//           ),
//           onMapCreated: (value) {
//             context.read<MapBloc>().add(MapCreated(controller: value));
//           },
//         ),
//       ),
//     );
//   }
// }

final class _MapView extends StatelessWidget {
  const _MapView();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colorScheme = Theme.of(context).colorScheme;
    final popupController = PopupController();
    return ColoredBox(
      color: colorScheme.background,
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) => Stack(
          children: [
            PopupScope(
              popupController: popupController,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: const LatLng(10.823099, 106.629662),
                  initialZoom: 14.4746,
                  maxZoom: 20.5,
                  backgroundColor: colorScheme.background,
                  onTap: (_, __) {
                    popupController.hideAllPopups();
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: switch (brightness) {
                      Brightness.light =>
                        'https://api.maptiler.com/maps/streets-v2/256/{z}/{x}/{y}@2x.png?key=${DartDefine.maptilerApiKey}',
                      Brightness.dark =>
                        'https://api.maptiler.com/maps/streets-v2-dark/256/{z}/{x}/{y}@2x.png?key=${DartDefine.maptilerApiKey}',
                    },
                    fallbackUrl:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.verygoodcore.workaround',
                    tileProvider: CancellableNetworkTileProvider(),
                  ),
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      maxClusterRadius: 80,
                      spiderfyCircleRadius: 80,
                      spiderfySpiralDistanceMultiplier: 2,
                      size: const Size(40, 40),
                      rotate: true,
                      maxZoom: 20.5,
                      polygonOptions: PolygonOptions(
                        borderColor: colorScheme.primaryContainer,
                        borderStrokeWidth: 2,
                      ),
                      // popupOptions: PopupOptions(
                      //   popupAnimation: const PopupAnimation.fade(),
                      //   popupController: popupController,
                      //   buildPopupOnHover: true,
                      //   popupBuilder: (context, marker) => Padding(
                      //     padding: const EdgeInsets.all(10),
                      //     child: Container(
                      //       constraints: const BoxConstraints(
                      //         minWidth: 100,
                      //         maxWidth: 200,
                      //       ),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: <Widget>[
                      //           Text(
                      //             marker.,
                      //             style: const TextStyle(fontSize: 12.0),
                      //           ),
                      //           Text(
                      //             'Marker size: ${marker.width}, ${marker.height}',
                      //             style: const TextStyle(fontSize: 12.0),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      markers: List.from(
                        state.mapWorks.map(
                          (e) => Marker(
                            point: LatLng(e.work.lat, e.work.lng),
                            rotate: true,
                            width: 140,
                            height: 30,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                  color: colorScheme.tertiary.withOpacity(0.2),
                                ),
                                color: colorScheme.primaryContainer,
                              ),
                              child: Center(
                                child: Text(
                                  e.work.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: colorScheme.primary,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        growable: false,
                      ),
                      builder: (context, markers) {
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.tertiary.withOpacity(0.1),
                            ),
                            color: colorScheme.tertiaryContainer,
                          ),
                          child: Center(
                            child: Text(
                              '+${markers.length}',
                              style: TextStyle(
                                color: colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  CurrentLocationLayer(),
                  RichAttributionWidget(
                    popupInitialDisplayDuration: const Duration(seconds: 5),
                    animationConfig: const ScaleRAWA(),
                    showFlutterMapAttribution: false,
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
