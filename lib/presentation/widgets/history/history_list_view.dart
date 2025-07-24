import 'package:flutter/material.dart';
import '../../../data/model/history/history_item.dart';
import '../../theme/app_colors.dart';
import 'history_item_tile.dart';

class HistoryListView extends StatelessWidget {
  final List<HistoryItem> items;
  final String emptyMessage;
  final IconData emptyIcon;
  final VoidCallback? onRefresh;
  final Function(HistoryItem)? onItemTap;

  const HistoryListView({
    super.key,
    required this.items,
    required this.emptyMessage,
    this.emptyIcon = Icons.history,
    this.onRefresh,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _buildEmptyState();
    }

    Widget listView = ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return HistoryItemTile(
          item: item,
          onTap: onItemTap != null ? () => onItemTap!(item) : null,
        );
      },
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: () async => onRefresh!(),
        child: listView,
      );
    }

    return listView;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(emptyIcon, size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            _getEmptyTitle(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              emptyMessage,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _getEmptyTitle() {
    if (emptyIcon == Icons.qr_code_scanner) {
      return 'No Check-ins Yet';
    } else if (emptyIcon == Icons.event_seat) {
      return 'No Bookings Yet';
    } else if (emptyIcon == Icons.payment) {
      return 'No Payments Yet';
    } else {
      return 'No History Yet';
    }
  }
}
