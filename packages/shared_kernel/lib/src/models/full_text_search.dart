import 'package:equatable/equatable.dart';

final class FullTextSearch extends Equatable {
  const FullTextSearch({
    required this.column,
    required this.query,
  });

  final String column;
  final String query;

  @override
  List<Object?> get props => [column, query];
}
