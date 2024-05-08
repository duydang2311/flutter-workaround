import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_client/location_client.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/dart_define.gen.dart';
import 'package:workaround/home_scaffold/home_scaffold.dart';
import 'package:workaround/map/bloc/map_bloc.dart';
import 'package:workaround/map/map.dart';
import 'package:workaround/theme/theme.dart';

final class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeScaffoldBloc>();
    bloc.add(
      HomeScaffoldChanged(
        scaffoldMap: {
          ...bloc.state.scaffoldMap,
          'map': ScaffoldData(
            appBar: ThemedAppBar(
              title: const ThemedAppBarTitle(
                'Binh Thanh, Ho Chi Minh City',
              ),
              bottom: PreferredSize(
                preferredSize: Size(
                  double.infinity,
                  ProgressIndicatorTheme.of(context).linearMinHeight!,
                ),
                child: BlocBuilder<HomeScaffoldBloc, HomeScaffoldState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) => switch (state.status) {
                    HomeScaffoldStatus.pending =>
                      const LinearProgressIndicator(),
                    _ => const SizedBox.shrink(),
                  },
                ),
              ),
            ),
          ),
        },
      ),
    );
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

final class _MapView extends StatefulWidget {
  const _MapView();

  @override
  State<StatefulWidget> createState() => _MapViewState();
}

final class _MapViewState extends State<_MapView> {
  final PopupController _popupController = PopupController();

  @override
  void dispose() {
    _popupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocListener<MapBloc, MapState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        context.read<HomeScaffoldBloc>().add(
              HomeScaffoldStatusChanged(
                status: switch (state.status) {
                  MapStatus.pending => HomeScaffoldStatus.pending,
                  _ => HomeScaffoldStatus.none,
                },
              ),
            );
      },
      child: PopupScope(
        popupController: _popupController,
        child: ColoredBox(
          color: colorScheme.background,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(10.823099, 106.629662),
              initialZoom: 14.4746,
              maxZoom: 20.5,
              backgroundColor: colorScheme.background,
              onTap: (_, __) {
                _popupController.hideAllPopups();
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
                fallbackUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.verygoodcore.workaround',
                tileProvider: CancellableNetworkTileProvider(),
              ),
              BlocBuilder<MapBloc, MapState>(
                buildWhen: (previous, current) =>
                    previous.positionStream != current.positionStream,
                builder: (context, state) => CurrentLocationLayer(
                  positionStream: state.positionStream.map(
                    (position) => LocationMarkerPosition(
                      latitude: position.latitude,
                      longitude: position.longitude,
                      accuracy: position.accuracy,
                    ),
                  ),
                  headingStream: state.positionStream.map(
                    (position) => LocationMarkerHeading(
                      heading: degToRadian(position.heading),
                      accuracy: degToRadian(position.headingAccuracy),
                    ),
                  ),
                  moveAnimationDuration: const Duration(milliseconds: 500),
                ),
              ),
              BlocBuilder<MapBloc, MapState>(
                buildWhen: (previous, current) =>
                    previous.mapWorks != current.mapWorks,
                builder: (context, state) {
                  final markers = state.mapWorks
                      .map(
                        (work) => WorkMarker(
                          key: ValueKey(work.id),
                          workId: work.id,
                          point: LatLng(work.lat, work.lng),
                          rotate: true,
                          width: 140,
                          height: 40,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    border: Border.all(
                                      color:
                                          colorScheme.primary.withOpacity(0.2),
                                    ),
                                    color: colorScheme.primaryContainer,
                                  ),
                                  child: Center(
                                    child: Text(
                                      work.title,
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
                              Container(
                                width: 8,
                                height: 8,
                                decoration: ShapeDecoration(
                                  color: colorScheme.primaryContainer,
                                  shape: TriangleShapeBorder(
                                    border: DynamicBorderSide(
                                      begin: const Length(8),
                                      color:
                                          colorScheme.primary.withOpacity(0.2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(growable: false);
                  return MarkerClusterLayerWidget(
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
                      popupOptions: PopupOptions(
                        popupAnimation: const PopupAnimation.fade(),
                        popupController: _popupController,
                        popupBuilder: (context, marker) {
                          if (marker is! WorkMarker) {
                            return const SizedBox.shrink();
                          }

                          final work = state.mapWorks
                              .firstWhereOrNull((e) => e.id == marker.workId);
                          if (work == null) {
                            return const SizedBox.shrink();
                          }

                          log('popup ${work.title}');
                          return WorkPopup(
                            key: ValueKey(work.id),
                            work: work,
                          );
                        },
                      ),
                      markers: markers,
                      onMarkerTap: (marker) {
                        if (marker is! WorkMarker) return;
                        context
                            .read<MapBloc>()
                            .add(MapWorkTapped(marker.workId));
                      },
                      builder: (context, markers) {
                        return WorkCluster(size: markers.length);
                      },
                    ),
                  );
                },
              ),
              RichAttributionWidget(
                popupInitialDisplayDuration: const Duration(seconds: 5),
                animationConfig: const ScaleRAWA(),
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
      ),
    );
  }
}
