import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/utils/app_logger.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

@injectable
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityBloc(this._connectivityService)
    : super(const ConnectivityInitial()) {
    on<ConnectivityInitialize>(_onConnectivityInitialize);
    on<ConnectivityChanged>(_onConnectivityChanged);
    on<ConnectivityReset>(_onConnectivityReset);
  }

  Future<void> _onConnectivityInitialize(
    ConnectivityInitialize event,
    Emitter<ConnectivityState> emit,
  ) async {
    try {
      // Listen for connectivity changes
      _connectivitySubscription = _connectivityService.connectivityStream
          .listen(
            (results) {
              if (!isClosed) {
                add(ConnectivityChanged(results));
              }
            },
            onError: (error) {
              // Handle stream errors gracefully
              if (!isClosed) {
                // Optionally emit an error state or log the error
                AppLogger.error(
                  'Connectivity stream error',
                  error: error,
                  tag: 'Connectivity',
                );
              }
            },
          );

      // Check initial connectivity
      final results = await _connectivityService.checkConnectivity();
      if (!isClosed) {
        add(ConnectivityChanged(results));
      }
    } catch (e) {
      // Handle initialization errors
      AppLogger.error(
        'Connectivity initialization error',
        error: e,
        tag: 'Connectivity',
      );
    }
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    final isConnected = _connectivityService.isConnected(event.results);
    final isWiFi = _connectivityService.isConnectedToWiFi(event.results);
    final isMobile = _connectivityService.isConnectedToMobile(event.results);

    if (isConnected) {
      emit(
        ConnectivityConnected(
          connectivityResult: event.results,
          isWiFi: isWiFi,
          isMobile: isMobile,
        ),
      );
    } else {
      emit(const ConnectivityDisconnected());
    }

    // Log connectivity changes
    final connectionType = isWiFi
        ? 'WiFi'
        : isMobile
        ? 'Mobile'
        : 'None';
    AppLogger.connectivity('Connection changed to: $connectionType');
  }

  void _onConnectivityReset(
    ConnectivityReset event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(const ConnectivityInitial());
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
