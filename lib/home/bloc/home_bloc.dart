import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_client/location_client.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:user_repository/user_repository.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/home/home.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required WorkFilter filter,
    required WorkRepository workRepository,
    required LocationClient locationClient,
    required AppUserRepository appUserRepository,
  })  : _workRepository = workRepository,
        _locationClient = locationClient,
        _appUserRepository = appUserRepository,
        super(HomeState(filter: filter)) {
    on<HomeInitialized>(_handleInitialized);
    on<HomeRefreshRequested>(_handleRefreshRequested);
    on<HomeWorkFilterChanged>(_handleWorkFilterChanged);
    on<HomeWorkChanged>(_handleWorkChanged);
    on<HomeMoreWorksRequested>(_handleMoreWorksRequested);
  }

  static const int _pageSize = 10;
  final WorkRepository _workRepository;
  final LocationClient _locationClient;
  final AppUserRepository _appUserRepository;

  Future<void> _handleInitialized(
    HomeInitialized event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: UiStatus.loading));
    final works = await _getHomeWorks().match(
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
        status: UiStatus.none,
        works: works,
        hasReachedMax: works.length < _pageSize,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Future<void> _handleRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: UiStatus.loading));
    final works = await _getHomeWorks().match(
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
        status: UiStatus.none,
        works: works,
        hasReachedMax: works.length < _pageSize,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Future<void> _handleWorkFilterChanged(
    HomeWorkFilterChanged event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(status: UiStatus.loading, filter: event.filter),
    );
    final works = await _getHomeWorks().match(
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
        status: UiStatus.none,
        works: works,
        hasReachedMax: works.length < _pageSize,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  void _handleWorkChanged(
    HomeWorkChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        works: state.works
            .map((e) => e.id != event.id ? e : e.copyWith(status: event.status))
            .toList(),
      ),
    );
  }

  Future<void> _handleMoreWorksRequested(
    HomeMoreWorksRequested event,
    Emitter<HomeState> emit,
  ) async {
    final works =
        await _getHomeWorks(offset: state.works.length, limit: _pageSize).match(
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
        status: UiStatus.none,
        works: [...state.works, ...works],
        hasReachedMax: works.length < _pageSize,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  TaskEither<GenericError, List<HomeWork>> _getHomeWorks({
    int? offset,
    int? limit,
  }) =>
      _locationClient
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
                  descriptionLength: 160,
                  ownerId: switch (state.filter) {
                    WorkFilter.own =>
                      _appUserRepository.currentUser.toNullable()!.id,
                    _ => null,
                  },
                  limit: limit ?? _pageSize,
                  offset: offset,
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
                          ownerName: e.ownerName,
                          status: e.status,
                          distance: Option.of(e.distance),
                          description: Option.fromNullable(e.description),
                        ),
                      )
                      .toList(),
                ),
          )
          .orElse(
            (l) => _workRepository
                .getWorks(
                  from: 'home_page_works',
                  columns: '''
              id, created_at, title, lat, lng, address, status, description,
              owner:profiles!owner_id(display_name)
            ''',
                  order: const ColumnOrder(column: 'created_at'),
                  match: {
                    'status': WorkStatus.open.name,
                    if (state.filter.isOwn)
                      'owner_id':
                          _appUserRepository.currentUser.toNullable()!.id,
                  },
                  range: RowRange(
                    from: offset ?? 0,
                    to: (offset ?? 0) + _pageSize,
                  ),
                )
                .map(
                  (r) => r
                      .map(
                        (e) => HomeWork(
                          id: e['id'] as String,
                          ownerName: (e['owner']
                                  as Map<String, dynamic>)['display_name']
                              as String,
                          createdAt: DateTime.parse(e['created_at'] as String),
                          title: e['title'] as String,
                          address: e['address'] as String,
                          lat: e['lat'] as double,
                          lng: e['lng'] as double,
                          status:
                              WorkStatus.values.byName(e['status'] as String),
                          description:
                              Option.fromNullable(e['description'] as String?),
                        ),
                      )
                      .toList(),
                ),
          );
}
