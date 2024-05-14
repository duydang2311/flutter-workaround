import 'package:work_repository/work_repository.dart';

final class NearbyWorkWithDescription extends NearbyWork {
  const NearbyWorkWithDescription({
    required super.id,
    required super.createdAt,
    required super.ownerName,
    required super.title,
    required super.address,
    required super.lat,
    required super.lng,
    required super.distance,
    required super.status,
    required this.description,
  });

  final String? description;

  @override
  List<Object?> get props => super.props..addAll([description]);
}
