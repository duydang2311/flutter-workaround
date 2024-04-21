part of 'bottom_sheet_bloc.dart';

sealed class BottomSheetEvent extends Equatable {
  const BottomSheetEvent();

  @override
  List<Object> get props => [];
}

final class BottomSheetAddressChanged extends BottomSheetEvent {
  const BottomSheetAddressChanged({required this.address});

  final String address;

  @override
  List<Object> get props => [address];
}

final class BottomSheetPendingChanged extends BottomSheetEvent {
  const BottomSheetPendingChanged({required this.pending});

  final bool pending;

  @override
  List<Object> get props => [pending];
}

final class BottomSheetSuggestionsChanged extends BottomSheetEvent {
  const BottomSheetSuggestionsChanged({required this.suggestions});

  final List<Suggestion> suggestions;

  @override
  List<Object> get props => [suggestions];
}

final class BottomSheetLocationSelected extends BottomSheetEvent {
  const BottomSheetLocationSelected({required this.index});

  final int index;

  @override
  List<Object> get props => [index];
}
