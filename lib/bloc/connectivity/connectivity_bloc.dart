import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../core/services/connectivity_service.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

@injectable
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityBloc(this._connectivityService)
    : super(ConnectivityState.initial()) {
    on<ConnectivityInitialized>(_onConnectivityInitialized);
    on<ConnectivityChanged>(_onConnectivityChanged);
    on<ConnectivityCheckRequested>(_onConnectivityCheckRequested);
  }

  Future<void> _onConnectivityInitialized(
    ConnectivityInitialized event,
    Emitter<ConnectivityState> emit,
  ) async {
    // Start listening to connectivity changes
    _connectivitySubscription = _connectivityService.connectivityStream.listen(
      (results) => add(ConnectivityChanged(results)),
    );

    // Check initial connectivity
    final results = await _connectivityService.checkConnectivity();
    add(ConnectivityChanged(results));
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    final isConnected = _connectivityService.isConnected(event.results);
    final isWiFi = _connectivityService.isConnectedToWiFi(event.results);
    final isMobile = _connectivityService.isConnectedToMobile(event.results);
    final connectionType = _connectivityService.getConnectionType(
      event.results,
    );

    emit(
      ConnectivityState.fromResults(
        event.results,
        connectionType,
        isConnected,
        isWiFi,
        isMobile,
      ),
    );
  }

  Future<void> _onConnectivityCheckRequested(
    ConnectivityCheckRequested event,
    Emitter<ConnectivityState> emit,
  ) async {
    final results = await _connectivityService.checkConnectivity();
    add(ConnectivityChanged(results));
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
