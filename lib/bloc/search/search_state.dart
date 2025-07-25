import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchTyping extends SearchState {
  final String query;

  const SearchTyping(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchLoading extends SearchState {
  final String query;

  const SearchLoading(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchSuccess extends SearchState {
  final String query;
  final List<dynamic> results; // Replace with actual search result type

  const SearchSuccess(this.query, this.results);

  @override
  List<Object?> get props => [query, results];
}

class SearchFailure extends SearchState {
  final String query;
  final String error;

  const SearchFailure(this.query, this.error);

  @override
  List<Object?> get props => [query, error];
}
