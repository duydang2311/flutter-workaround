part of 'work_bloc.dart';

final class WorkState extends Equatable {
  WorkState({
    this.work = const Option.none(),
    BitField<UiStatus>? status,
    this.error = const Option.none(),
    this.applicationId = const Option.none(),
    this.isRecruiter = false,
  }) : status = status ?? BitField.empty();

  final Option<Work> work;
  final BitField<UiStatus> status;
  final Option<UiError> error;
  final Option<String> applicationId;
  final bool isRecruiter;

  WorkState copyWith({
    Option<Work>? work,
    BitField<UiStatus>? status,
    Option<UiError>? error,
    Option<String>? applicationId,
    bool? isRecruiter,
  }) =>
      WorkState(
        work: work ?? this.work,
        status: status ?? this.status,
        error: error ?? this.error,
        applicationId: applicationId ?? this.applicationId,
        isRecruiter: isRecruiter ?? this.isRecruiter,
      );

  @override
  List<Object> get props => [
        work,
        status,
        error,
        applicationId,
        isRecruiter,
      ];
}
