import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_client/location_client.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/home/home.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required WorkRepository workRepository,
    required LocationClient locationClient,
  })  : _workRepository = workRepository,
        _locationClient = locationClient,
        super(const HomeState()) {
    on<HomeInitialized>(_handleInitialized);
    on<HomeRefreshRequested>(_handleRefreshRequested);
  }

  final WorkRepository _workRepository;
  final LocationClient _locationClient;

  Future<void> _handleInitialized(
    HomeInitialized event,
    Emitter<HomeState> emit,
  ) async {
    final works = await _getHomeWorks.match(
      (l) {
        emit(
          state.copyWith(
            error: Option.of(UiError.now(message: l.formatted)),
          ),
        );
        return <HomeWork>[];
      },
      (r) => r,
    ).run();
    emit(
      state.copyWith(
        works: works,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Future<void> _handleRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    final works = await _getHomeWorks.match(
      (l) {
        emit(
          state.copyWith(
            error: Option.of(UiError.now(message: l.formatted)),
          ),
        );
        return <HomeWork>[];
      },
      (r) => r,
    ).run();
    emit(
      state.copyWith(
        works: works,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  TaskEither<GenericError, List<HomeWork>> get _getHomeWorks => _locationClient
      .checkPermission()
      .toTaskEither<GenericError>()
      .flatMap(
        (r) => switch (r) {
          LocationPermission.denied => _locationClient.requestPermission(),
          _ => TaskEither.right(r),
        },
      )
      .flatMap<LocationPermission>(
        (r) => switch (r) {
          LocationPermission.always ||
          LocationPermission.whileInUse =>
            TaskEither.right(r),
          _ => TaskEither.left(const GenericError.unknown()),
        },
      )
      .flatMap((r) => _locationClient.getCurrentPosition())
      .flatMap(
        (r) => _workRepository
            .getNearbyWorksWithDescription(
              r.latitude,
              r.longitude,
              limit: 10,
              descriptionLength: 160,
            )
            .map(
              (r) => r
                  .map(
                    (e) => HomeWork(
                      id: e.id,
                      createdAt: e.createdAt,
                      title: e.title,
                      address: e.address,
                      lat: e.lat,
                      lng: e.lng,
                      distance: Option.of(e.distance),
                      description: Option.of(e.description),
                      ownerName: e.ownerName,
                    ),
                  )
                  .toList(),
            ),
      )
      .orElse((l) => _workRepository
          .getWorks(
            from: 'home_page_works',
            columns:
                'id, created_at, title, lat, lng, address, description, owner:profiles!owner_id(display_name)',
            order: const ColumnOrder(column: 'created_at'),
          )
          .map(
            (r) => r
                .map(
                  (e) => HomeWork(
                    id: e['id'] as String,
                    ownerName: (e['owner']
                        as Map<String, dynamic>)['display_name'] as String,
                    createdAt: DateTime.parse(e['created_at'] as String),
                    title: e['title'] as String,
                    address: e['address'] as String,
                    lat: e['lat'] as double,
                    lng: e['lng'] as double,
                    description:
                        Option.fromNullable(e['description'] as String?),
                  ),
                )
                .toList(),
          ));
}
