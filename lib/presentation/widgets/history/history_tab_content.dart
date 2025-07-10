import 'package:flutter/material.dart';
import '../../../bloc/history/history_bloc.dart';
import '../../../data/model/history_item.dart';
import 'history_list_view.dart';
import 'history_config.dart';

class HistoryTabContent extends StatelessWidget {
  final int tabIndex;
  final HistoryState state;
  final VoidCallback onRefresh;
  final Function(HistoryItem)? onItemTap;

  const HistoryTabContent({
    super.key,
    required this.tabIndex,
    required this.state,
    required this.onRefresh,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (state is HistoryLoading || state is HistorySyncing) {
      return _buildLoadingState();
    }

    if (state is HistoryLoaded || state is HistorySyncSuccess) {
      final items = state is HistoryLoaded
          ? (state as HistoryLoaded).items
          : (state as HistorySyncSuccess).items;

      final filteredItems = _filterItemsForTab(items);

      return HistoryListView(
        items: filteredItems,
        emptyMessage: HistoryTabHelper.getEmptyMessageForTab(tabIndex),
        emptyIcon: HistoryTabHelper.getIconForType(
          HistoryTabHelper.getHistoryTypeForTab(tabIndex),
        ),
        onRefresh: onRefresh,
        onItemTap: onItemTap,
      );
    }

    if (state is HistoryError) {
      return _buildErrorState((state as HistoryError).message);
    }

    return _buildInitialState();
  }

  List<HistoryItem> _filterItemsForTab(List<HistoryItem> items) {
    final type = HistoryTabHelper.getHistoryTypeForTab(tabIndex);
    if (type == null) {
      return items; // All items for "All" tab
    }
    return items.where((item) => item.type == type).toList();
  }

  Widget _buildLoadingState() {
    final isSync = state is HistorySyncing;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: isSync ? Colors.blue : Colors.orange,
          ),
          const SizedBox(height: 16),
          Text(
            isSync ? 'Syncing with server...' : 'Loading history...',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Oops! Something went wrong',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRefresh, child: const Text('Try Again')),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Welcome to History',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Pull down to refresh and load your activity history',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
