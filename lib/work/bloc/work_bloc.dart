import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:work_repository/work_repository.dart' hide Work;
import 'package:workaround/work/work.dart';

part 'work_event.dart';
part 'work_state.dart';

class WorkBloc extends Bloc<WorkEvent, WorkState> {
  WorkBloc({
    required String id,
    required WorkRepository workRepository,
  })  : _id = id,
        _workRepository = workRepository,
        super(const WorkState()) {
    on<WorkInitialized>(_handleInitialized);
    on<WorkRefreshRequested>(_handleRefreshRequested);
  }

  final String _id;
  final WorkRepository _workRepository;

  Future<void> _handleInitialized(
    WorkInitialized event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(status: WorkStatus.loading));
    final work = await _getWork.run();
    work.match((l) {
      emit(
        state.copyWith(
          status: WorkStatus.none,
          error: Option.of(UiError.now(message: l.formatted)),
        ),
      );
    }, (r) {
      emit(state.copyWith(status: WorkStatus.none, work: Option.of(r)));
    });
  }

  Future<void> _handleRefreshRequested(
    WorkRefreshRequested event,
    Emitter<WorkState> emit,
  ) async {
    emit(state.copyWith(status: WorkStatus.loading));
    final work = await _getWork.run();
    work.match((l) {
      emit(
        state.copyWith(
          status: WorkStatus.none,
          error: Option.of(UiError.now(message: l.formatted)),
        ),
      );
    }, (r) {
      emit(state.copyWith(status: WorkStatus.none, work: Option.of(r)));
    });
  }

  TaskEither<GenericError, Work> get _getWork => _workRepository.getWorkById(
        _id,
        columns: '''
          id, created_at, title, address, description,
          owner:owner_id(display_name)
        ''',
      ).map(
        (r) => Work(
          id: r['id'] as String,
          createdAt: DateTime.parse(r['created_at'] as String),
          ownerName:
              (r['owner'] as Map<String, dynamic>)['display_name'] as String,
          title: r['title'] as String,
          address: r['address'] as String,
          description: Option.of(r['description'] as String),
        ),
      );
}
