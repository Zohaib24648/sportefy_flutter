import 'package:flutter/material.dart';
import '../../../data/model/history_item.dart';
import '../../theme/app_colors.dart';
import 'history_indicators.dart';

class HistoryItemTile extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback? onTap;
  final Widget? trailing;

  const HistoryItemTile({
    super.key,
    required this.item,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getStatusColor(item.status).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: HistoryTypeIcon(
            type: item.type,
            color: _getStatusColor(item.status),
          ),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.description != null)
              Text(
                item.description!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            const SizedBox(height: 4),
            Text(
              _formatDateTime(item.createdAt),
              style: const TextStyle(fontSize: 12),
            ),
            if (_hasMetadataToShow())
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _buildMetadataRow(),
              ),
          ],
        ),
        trailing: trailing ?? _buildDefaultTrailing(),
      ),
    );
  }

  Widget _buildDefaultTrailing() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HistoryStatusIndicator(status: item.status),
        const SizedBox(height: 4),
        SyncStatusIndicator(isSynced: item.isSynced),
      ],
    );
  }

  Widget _buildMetadataRow() {
    switch (item.type) {
      case HistoryType.booking:
        final amount = item.metadata['amount'];
        final reference = item.metadata['bookingReference'];
        return Row(
          children: [
            if (amount != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '\$${amount.toString()}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            if (amount != null && reference != null) const SizedBox(width: 8),
            if (reference != null)
              Expanded(
                child: Text(
                  'Ref: $reference',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        );
      case HistoryType.payment:
        final amount = item.metadata['amount'];
        final paymentMethod = item.metadata['paymentMethod'];
        return Row(
          children: [
            if (amount != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(item.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '\$${amount.toString()}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(item.status),
                  ),
                ),
              ),
            if (amount != null && paymentMethod != null)
              const SizedBox(width: 8),
            if (paymentMethod != null)
              Expanded(
                child: Text(
                  paymentMethod,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        );
      case HistoryType.checkIn:
        final eventName = item.metadata['eventName'];
        if (eventName != null && eventName != item.title) {
          return Text(
            'Event: $eventName',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          );
        }
        return const SizedBox.shrink();
    }
  }

  bool _hasMetadataToShow() {
    switch (item.type) {
      case HistoryType.booking:
        return item.metadata['amount'] != null ||
            item.metadata['bookingReference'] != null;
      case HistoryType.payment:
        return item.metadata['amount'] != null ||
            item.metadata['paymentMethod'] != null;
      case HistoryType.checkIn:
        final eventName = item.metadata['eventName'];
        return eventName != null && eventName != item.title;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
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
