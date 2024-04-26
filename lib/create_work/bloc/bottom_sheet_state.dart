part of 'bottom_sheet_bloc.dart';

final class BottomSheetState extends Equatable {
  const BottomSheetState({
    required this.address,
    required this.suggestions,
    required this.pending,
    required this.selected,
    required this.selectedTimestamp,
  });

  final Address address;
  final List<Suggestion> suggestions;
  final bool pending;
  final Option<Suggestion> selected;
  final int selectedTimestamp;

  BottomSheetState copyWith({
    Address? address,
    List<Suggestion>? suggestions,
    bool? pending,
    Option<Suggestion>? selected,
    int? selectedTimestamp,
  }) =>
      BottomSheetState(
        address: address ?? this.address,
        suggestions: suggestions ?? this.suggestions,
        pending: pending ?? this.pending,
        selected: selected ?? this.selected,
        selectedTimestamp: selectedTimestamp ?? this.selectedTimestamp,
      );

  @override
  List<Object?> get props => [
        address,
        suggestions,
        pending,
        selected,
        selectedTimestamp,
      ];
}
