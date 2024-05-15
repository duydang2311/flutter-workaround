part of 'search_bloc.dart';

final class SearchState extends Equatable {
  const SearchState({
    this.isLoading = false,
    this.works = const [],
    this.error = const Option.none(),
  });

  final bool isLoading;
  final List<SearchWork> works;
  final Option<UiError> error;

  SearchState copyWith({
    bool? isLoading,
    List<SearchWork>? works,
    Option<UiError>? error,
  }) =>
      SearchState(
        isLoading: isLoading ?? this.isLoading,
        works: works ?? this.works,
        error: error ?? this.error,
      );

  @override
  List<Object> get props => [isLoading, works, error];
}
