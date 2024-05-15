import 'package:bloc/bloc.dart';
import 'package:dartfield/dartfield.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:user_repository/user_repository.dart';
import 'package:work_application_repository/work_application_repository.dart';
import 'package:work_repository/work_repository.dart' hide Work;
import 'package:workaround/extension/dartfield_extension.dart';
import 'package:workaround/work/work.dart';

part 'work_event.dart';
part 'work_state.dart';

class WorkBloc extends Bloc<WorkEvent, WorkState> {
  WorkBloc({
    required String id,
    required WorkRepository workRepository,
    required AppUserRepository appUserRepository,
    required WorkApplicationRepository workApplicationRepository,
  })  : _id = id,
        _workRepository = workRepository,
        _appUserRepository = appUserRepository,
        _workApplicationRepository = workApplicationRepository,
        super(WorkState()) {
    on<WorkInitialized>(_handleInitialized);
    on<WorkRefreshRequested>(_handleRefreshRequested);
    on<WorkApplyRequested>(_handleApplyRequested);
    on<WorkUnapplyRequested>(_handleUnapplyRequested);
    on<WorkStatusChanged>(_handleStatusChanged);
  }

  final String _id;
  final WorkRepository _workRepository;
  final AppUserRepository _appUserRepository;
  final WorkApplicationRepository _workApplicationRepository;

  Future<void> _handleInitialized(
    WorkInitialized event,
    Emitter<WorkState> emit,
  ) async {
    emit(
      state.copyWith(
        status: state.status.clone()..add(UiStatus.loading),
      ),
    );
    final (work, applicationId) =
        await (_getWork.run(), _getApplicationId.run()).wait;
    emit(
      work
          .match(
            (l) => state.copyWith(
              status: state.status.clone()..remove(UiStatus.loading),
              error: Option.of(UiError.now(message: l.formatted)),
            ),
            (r) => state.copyWith(
              status: state.status.clone()..remove(UiStatus.loading),
              work: Option.of(r),
              isRecruiter: r.recruiterId ==
                  _appUserRepository.currentUser.toNullable()!.id,
            ),
          )
          .copyWith(applicationId: applicationId.toOption()),
    );
  }

  Future<void> _handleRefreshRequested(
    WorkRefreshRequested event,
    Emitter<WorkState> emit,
  ) async {
    emit(
      state.copyWith(status: state.status.clone()..add(UiStatus.loading)),
    );
    final work = await _getWork.run();
    work.match((l) {
      emit(
        state.copyWith(
          status: state.status.clone()..remove(UiStatus.loading),
          error: Option.of(UiError.now(message: l.formatted)),
        ),
      );
    }, (r) {
      emit(
        state.copyWith(
          status: state.status.clone()..remove(UiStatus.loading),
          work: Option.of(r),
        ),
      );
    });
  }

  Future<void> _handleApplyRequested(
    WorkApplyRequested event,
    Emitter<WorkState> emit,
  ) async {
    emit(
      state.copyWith(status: state.status.clone()..add(UiStatus.fabLoading)),
    );
    await TaskEither.fromOption(
      _appUserRepository.currentUser,
      () => const GenericError(message: 'Unable to detect user.'),
    )
        .flatMap(
      (r) => _workApplicationRepository.insert(
        WorkApplication(
          workId: _id,
          applicantId: r.id,
        ),
        columns: 'id',
      ),
    )
        .match((l) {
      emit(
        state.copyWith(
          status: state.status.clone()..remove(UiStatus.fabLoading),
          error: Option.of(UiError.now(message: l.formatted)),
        ),
      );
    }, (r) {
      emit(
        state.copyWith(
          status: state.status.clone()..remove(UiStatus.fabLoading),
          applicationId: Option.of((r as Map<String, dynamic>)['id'] as String),
        ),
      );
    }).run();
  }

  Future<void> _handleUnapplyRequested(
    WorkUnapplyRequested event,
    Emitter<WorkState> emit,
  ) async {
    emit(
      state.copyWith(status: state.status.clone()..add(UiStatus.fabLoading)),
    );
    await TaskEither.fromOption(
      state.applicationId,
      () => const GenericError(message: 'Unable to detect application ID.'),
    )
        .flatMap(
      (r) => _workApplicationRepository.delete(id: r),
    )
        .match((l) {
      emit(
        state.copyWith(
          status: state.status.clone()..remove(UiStatus.fabLoading),
          error: Option.of(UiError.now(message: l.formatted)),
        ),
      );
    }, (r) {
      emit(
        state.copyWith(
          status: state.status.clone()..remove(UiStatus.fabLoading),
          applicationId: const Option.none(),
        ),
      );
    }).run();
  }

  Future<void> _handleStatusChanged(
    WorkStatusChanged event,
    Emitter<WorkState> emit,
  ) async {
    emit(
      state.copyWith(status: state.status.clone()..add(UiStatus.fabLoading)),
    );
    await _workRepository.update({'status': event.status.name}, id: _id).match(
      (l) {
        emit(
          state.copyWith(
            status: state.status.clone()..remove(UiStatus.fabLoading),
            error: Option.of(UiError.now(message: l.formatted)),
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: state.status.clone()..remove(UiStatus.fabLoading),
            work: state.work.map((t) => t.copyWith(status: event.status)),
          ),
        );
      },
    ).run();
  }

  TaskEither<GenericError, Work> get _getWork => _workRepository.getWorkById(
        _id,
        columns: '''
          id, created_at, title, address, description, status,
          owner:owner_id(id, display_name)
        ''',
      ).map(
        (r) {
          final owner = r['owner'] as Map<String, dynamic>;
          return Work(
            id: r['id'] as String,
            createdAt: DateTime.parse(r['created_at'] as String),
            recruiterId: owner['id'] as String,
            recruiterName: owner['display_name'] as String,
            title: r['title'] as String,
            status: WorkStatus.values.byName(r['status'] as String),
            address: r['address'] as String,
            description: Option.fromNullable(r['description'] as String?),
          );
        },
      );

  TaskEither<GenericError, String> get _getApplicationId =>
      TaskEither.fromOption(
        _appUserRepository.currentUser,
        () => const GenericError(message: 'Unable to detect user.'),
      )
          .flatMap(
            (r) => _workApplicationRepository.getOne(
              workId: _id,
              applicantId: r.id,
              limit: 1,
              columns: 'id',
            ),
          )
          .map((r) => r['id'] as String);
}
