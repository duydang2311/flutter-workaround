import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/home/home.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required WorkRepository workRepository})
      : _workRepository = workRepository,
        super(const SearchState()) {
    on<SearchChanged>(
      _handleChanged,
      transformer: (events, mapper) => events
          .tap(_handleImmediateChange)
          .debounce(const Duration(milliseconds: 400))
          .switchMap(mapper),
    );
    on<SearchLoading>(_handleLoading);
  }

  final WorkRepository _workRepository;

  void _handleImmediateChange(SearchChanged e) {
    add(const SearchLoading());
  }

  void _handleLoading(
    SearchLoading event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(isLoading: true));
  }

  Future<void> _handleChanged(
    SearchChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final works = await _workRepository
        .getWorks(
          columns: 'id, created_at, title, address',
          match: {'status': WorkStatus.open.name},
          fullTextSearch: FullTextSearch(
            column: 'fts',
            query: event.query.split(' ').join(' & '),
          ),
          range: const RowRange(from: 0, to: 10),
        )
        .map(
          (r) => r
              .map(
                (e) => SearchWork(
                  id: e['id'] as String,
                  createdAt: DateTime.parse(e['created_at'] as String),
                  title: e['title'] as String,
                  address: e['address'] as String,
                ),
              )
              .toList(),
        )
        .match(
      (l) {
        emit(
          state.copyWith(
            error: Option.of(UiError.now(message: l.formatted)),
          ),
        );
        return <SearchWork>[];
      },
      (r) => r,
    ).run();
    emit(state.copyWith(isLoading: false, works: works));
  }
}
