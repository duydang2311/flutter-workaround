import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:work_repository/work_repository.dart';

final class MapWork extends Equatable {
  const MapWork({
    required this.work,
    this.details = const Option.none(),
  });

  final NearbyWork work;
  final Option<Work> details;

  MapWork copyWith({
    NearbyWork? work,
    Option<Work>? details,
  }) =>
      MapWork(
        work: work ?? this.work,
        details: details ?? this.details,
      );

  @override
  List<Object?> get props => [work, details];
}
