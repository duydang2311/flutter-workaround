import 'package:equatable/equatable.dart';

final class RowRange extends Equatable {
  const RowRange({
    required this.from,
    required this.to,
    this.referencedTable,
  });

  final int from;
  final int to;
  final String? referencedTable;

  @override
  List<Object?> get props => [from, to, referencedTable];
}
