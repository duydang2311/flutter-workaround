import 'package:equatable/equatable.dart';

final class SearchWork extends Equatable {
  const SearchWork({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.address,
  });

  final String id;
  final DateTime createdAt;
  final String title;
  final String address;

  SearchWork copyWith({
    String? id,
    DateTime? createdAt,
    String? title,
    String? address,
  }) =>
      SearchWork(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        title: title ?? this.title,
        address: address ?? this.address,
      );

  @override
  List<Object?> get props => [
        id,
        createdAt,
        title,
        address,
      ];
}
