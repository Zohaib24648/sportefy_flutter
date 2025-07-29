import 'package:equatable/equatable.dart';
import '../../data/model/sport_dto.dart';

abstract class SportsState extends Equatable {
  const SportsState();

  @override
  List<Object> get props => [];
}

class SportsInitial extends SportsState {
  const SportsInitial();
}

class SportsLoading extends SportsState {
  const SportsLoading();
}

class SportsLoaded extends SportsState {
  final List<SportDTO> sports;

  const SportsLoaded(this.sports);

  @override
  List<Object> get props => [sports];
}

class SportsError extends SportsState {
  final String message;

  const SportsError(this.message);

  @override
  List<Object> get props => [message];
}
