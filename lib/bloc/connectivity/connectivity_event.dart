import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityInitialized extends ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final List<ConnectivityResult> results;

  const ConnectivityChanged(this.results);

  @override
  List<Object> get props => [results];
}

class ConnectivityCheckRequested extends ConnectivityEvent {}
