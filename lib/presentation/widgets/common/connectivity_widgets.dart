import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/connectivity/connectivity_bloc.dart';
import '../../../bloc/connectivity/connectivity_state.dart';

class ConnectivityBanner extends StatefulWidget {
  final Widget child;

  const ConnectivityBanner({super.key, required this.child});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  ConnectivityStatus? _lastStatus;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        // Only show snackbar if status actually changed
        if (_lastStatus == state.status) return;

        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();

        if (state.status == ConnectivityStatus.disconnected) {
          messenger.showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.signal_wifi_off, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('No Internet Connection'),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(days: 1), // Keep until connected
            ),
          );
        } else if (state.isConnected &&
            _lastStatus == ConnectivityStatus.disconnected) {
          // Only show "connected" message when recovering from disconnected state
          messenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    state.isWiFi ? Icons.wifi : Icons.signal_cellular_4_bar,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text('Connected via ${state.connectionType}'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        _lastStatus = state.status;
      },
      child: widget.child,
    );
  }
}

class ConnectivityIndicator extends StatelessWidget {
  const ConnectivityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            state.isConnected
                ? (state.isWiFi ? Icons.wifi : Icons.signal_cellular_4_bar)
                : Icons.signal_wifi_off,
            color: state.isConnected ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            state.connectionType,
            style: TextStyle(
              color: state.isConnected ? Colors.green : Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
