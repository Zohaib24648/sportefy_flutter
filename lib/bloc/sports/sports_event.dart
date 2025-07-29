import 'package:equatable/equatable.dart';

abstract class SportsEvent extends Equatable {
  const SportsEvent();

  @override
  List<Object> get props => [];
}

class LoadSports extends SportsEvent {
  const LoadSports();
}

class RefreshSports extends SportsEvent {
  const RefreshSports();
}
