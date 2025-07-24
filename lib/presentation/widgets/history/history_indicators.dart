import 'package:flutter/material.dart';
import '../../../data/model/history/history_item.dart';

class HistoryStatusIndicator extends StatelessWidget {
  final HistoryStatus status;
  final bool showLabel;
  final double size;

  const HistoryStatusIndicator({
    super.key,
    required this.status,
    this.showLabel = false,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    final icon = _getStatusIcon(status);

    if (showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: size),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              color: color,
              fontSize: size * 0.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Icon(icon, color: color, size: size);
  }

  IconData _getStatusIcon(HistoryStatus status) {
    switch (status) {
      case HistoryStatus.success:
        return Icons.check_circle;
      case HistoryStatus.failed:
        return Icons.error;
      case HistoryStatus.pending:
        return Icons.hourglass_empty;
      case HistoryStatus.cancelled:
        return Icons.cancel;
      case HistoryStatus.refunded:
        return Icons.undo;
    }
  }

  Color _getStatusColor(HistoryStatus status) {
    switch (status) {
      case HistoryStatus.success:
        return Colors.green;
      case HistoryStatus.failed:
        return Colors.red;
      case HistoryStatus.pending:
        return Colors.orange;
      case HistoryStatus.cancelled:
        return Colors.grey;
      case HistoryStatus.refunded:
        return Colors.blue;
    }
  }
}

class HistoryTypeIcon extends StatelessWidget {
  final HistoryType type;
  final double size;
  final Color? color;

  const HistoryTypeIcon({
    super.key,
    required this.type,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getTypeIcon(type),
      size: size,
      color: color ?? Theme.of(context).iconTheme.color,
    );
  }

  IconData _getTypeIcon(HistoryType type) {
    switch (type) {
      case HistoryType.checkIn:
        return Icons.qr_code_scanner;
      case HistoryType.booking:
        return Icons.event_seat;
      case HistoryType.payment:
        return Icons.payment;
    }
  }
}

class SyncStatusIndicator extends StatelessWidget {
  final bool isSynced;
  final double size;

  const SyncStatusIndicator({
    super.key,
    required this.isSynced,
    this.size = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    if (isSynced) {
      return Icon(Icons.cloud_done, size: size, color: Colors.green);
    }

    return Icon(Icons.sync_disabled, size: size, color: Colors.orange);
  }
}
