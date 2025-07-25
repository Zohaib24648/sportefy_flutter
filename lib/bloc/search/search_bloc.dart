import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'search_event.dart';
import 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchSubmitted>(_onSearchSubmitted);
    on<SearchCleared>(_onSearchCleared);
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) {
    if (event.query.isEmpty) {
      emit(const SearchInitial());
    } else {
      emit(SearchTyping(event.query));
    }
  }

  void _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) return;

    emit(SearchLoading(event.query));

    try {
      // TODO: Implement actual search functionality
      // For now, just simulate a delay and return empty results
      await Future.delayed(const Duration(seconds: 1));
      emit(SearchSuccess(event.query, []));
    } catch (error) {
      emit(SearchFailure(event.query, error.toString()));
    }
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(const SearchInitial());
  }
}
