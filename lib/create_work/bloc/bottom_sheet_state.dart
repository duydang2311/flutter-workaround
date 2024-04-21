part of 'bottom_sheet_bloc.dart';

final class BottomSheetState extends Equatable {
  const BottomSheetState({
    required this.address,
    required this.suggestions,
    required this.pending,
  });

  final Address address;
  final List<Suggestion> suggestions;
  final bool pending;

  BottomSheetState copyWith({
    Address? address,
    List<Suggestion>? suggestions,
    bool? pending,
  }) =>
      BottomSheetState(
        address: address ?? this.address,
        suggestions: suggestions ?? this.suggestions,
        pending: pending ?? this.pending,
      );

  @override
  List<Object> get props => [address, suggestions, pending];
}
