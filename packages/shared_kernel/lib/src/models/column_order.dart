import 'package:equatable/equatable.dart';

final class ColumnOrder extends Equatable {
  const ColumnOrder({
    required this.column,
    this.ascending = false,
    this.nullsFirst = false,
    this.referencedTable,
  });

  final String column;
  final bool ascending;
  final bool nullsFirst;
  final String? referencedTable;

  @override
  List<Object?> get props => [column, ascending, nullsFirst, referencedTable];
}
