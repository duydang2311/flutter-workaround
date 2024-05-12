part of 'work_bloc.dart';

final class WorkState extends Equatable {
  const WorkState({
    this.work = const Option.none(),
    this.status = WorkStatus.none,
    this.error = const Option.none(),
  });

  final Option<Work> work;
  final WorkStatus status;
  final Option<UiError> error;

  WorkState copyWith({
    Option<Work>? work,
    WorkStatus? status,
    Option<UiError>? error,
  }) =>
      WorkState(
        work: work ?? this.work,
        status: status ?? this.status,
        error: error ?? this.error,
      );

  @override
  List<Object> get props => [work, status, error];
}
