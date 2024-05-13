part of 'work_bloc.dart';

sealed class WorkEvent extends Equatable {
  const WorkEvent();

  @override
  List<Object> get props => [];
}

final class WorkInitialized extends WorkEvent {
  const WorkInitialized();
}

final class WorkRefreshRequested extends WorkEvent {
  const WorkRefreshRequested();
}

final class WorkApplyRequested extends WorkEvent {
  const WorkApplyRequested();
}

final class WorkUnapplyRequested extends WorkEvent {
  const WorkUnapplyRequested();
}

final class WorkStatusChanged extends WorkEvent {
  const WorkStatusChanged(this.status);

  final WorkStatus status;

  @override
  List<Object> get props => [status];
}
