import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';

final class WorkMarker extends Marker with EquatableMixin {
  const WorkMarker({
    required super.point,
    required super.child,
    required this.workId,
    required super.width,
    required super.height,
    super.key,
    super.alignment,
    super.rotate,
  });

  final String workId;

  @override
  List<Object?> get props => [workId];
}
