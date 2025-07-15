import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

enum ConnectivityStatus { connected, disconnected, unknown }

class ConnectivityState extends Equatable {
  final ConnectivityStatus status;
  final List<ConnectivityResult> results;
  final String connectionType;
  final bool isConnected;
  final bool isWiFi;
  final bool isMobile;

  const ConnectivityState({
    required this.status,
    required this.results,
    required this.connectionType,
    required this.isConnected,
    required this.isWiFi,
    required this.isMobile,
  });

  factory ConnectivityState.initial() {
    return const ConnectivityState(
      status: ConnectivityStatus.unknown,
      results: [],
      connectionType: 'Unknown',
      isConnected: false,
      isWiFi: false,
      isMobile: false,
    );
  }

  factory ConnectivityState.fromResults(
    List<ConnectivityResult> results,
    String connectionType,
    bool isConnected,
    bool isWiFi,
    bool isMobile,
  ) {
    return ConnectivityState(
      status: isConnected
          ? ConnectivityStatus.connected
          : ConnectivityStatus.disconnected,
      results: results,
      connectionType: connectionType,
      isConnected: isConnected,
      isWiFi: isWiFi,
      isMobile: isMobile,
    );
  }

  ConnectivityState copyWith({
    ConnectivityStatus? status,
    List<ConnectivityResult>? results,
    String? connectionType,
    bool? isConnected,
    bool? isWiFi,
    bool? isMobile,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      results: results ?? this.results,
      connectionType: connectionType ?? this.connectionType,
      isConnected: isConnected ?? this.isConnected,
      isWiFi: isWiFi ?? this.isWiFi,
      isMobile: isMobile ?? this.isMobile,
    );
  }

  @override
  List<Object> get props => [
    status,
    results,
    connectionType,
    isConnected,
    isWiFi,
    isMobile,
  ];
}
