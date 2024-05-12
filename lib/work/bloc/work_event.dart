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
