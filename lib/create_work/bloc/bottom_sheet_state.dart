part of 'bottom_sheet_bloc.dart';

final class BottomSheetState extends Equatable {
  const BottomSheetState({
    required this.address,
    required this.suggestions,
    required this.pending,
    required this.selected,
  });

  final Address address;
  final List<Suggestion> suggestions;
  final bool pending;
  final Option<Suggestion> selected;

  BottomSheetState copyWith({
    Address? address,
    List<Suggestion>? suggestions,
    bool? pending,
    Option<Suggestion>? selected,
  }) =>
      BottomSheetState(
        address: address ?? this.address,
        suggestions: suggestions ?? this.suggestions,
        pending: pending ?? this.pending,
        selected: selected ?? this.selected,
      );

  @override
  List<Object?> get props => [address, suggestions, pending, selected];
}
