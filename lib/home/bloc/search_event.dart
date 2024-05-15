part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchLoading extends SearchEvent {
  const SearchLoading();
}

final class SearchChanged extends SearchEvent {
  const SearchChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}
