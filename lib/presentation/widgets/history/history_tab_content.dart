import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../../bloc/history/history_bloc.dart';
import '../../../data/model/history/history_item_dto.dart';
import '../common/shimmer_exports.dart';
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (isSync)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Syncing with server...',
                    style: TextStyle(color: AppColors.info),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) => const HistoryItemShimmer(),
            ),
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
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
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
              style: const TextStyle(fontSize: 14, color: AppColors.grey),
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
          Icon(Icons.history, size: 64, color: AppColors.grey),
          SizedBox(height: 16),
          Text(
            'Welcome to History',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Pull down to refresh and load your activity history',
            style: TextStyle(fontSize: 16, color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
