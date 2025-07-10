import 'package:flutter/material.dart';
import '../../../data/model/history_item.dart';
import '../../constants/app_colors.dart';

class HistoryTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final VoidCallback? onSyncPressed;
  final VoidCallback? onRefreshPressed;
  final VoidCallback? onLoadSampleData;

  const HistoryTabBar({
    super.key,
    required this.controller,
    this.onSyncPressed,
    this.onRefreshPressed,
    this.onLoadSampleData,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('History'),
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      actions: [
        if (onLoadSampleData != null)
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: onLoadSampleData,
            tooltip: 'Load sample data',
          ),
        if (onSyncPressed != null)
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: onSyncPressed,
            tooltip: 'Sync with server',
          ),
        if (onRefreshPressed != null)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onRefreshPressed,
            tooltip: 'Refresh',
          ),
      ],
      bottom: TabBar(
        controller: controller,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
        tabs: [
          Tab(icon: Icon(_getTabIcon(0)), text: _getTabTitle(0)),
          Tab(icon: Icon(_getTabIcon(1)), text: _getTabTitle(1)),
          Tab(icon: Icon(_getTabIcon(2)), text: _getTabTitle(2)),
          Tab(icon: Icon(_getTabIcon(3)), text: _getTabTitle(3)),
        ],
      ),
    );
  }

  IconData _getTabIcon(int index) {
    switch (index) {
      case 0:
        return Icons.qr_code_scanner;
      case 1:
        return Icons.event_seat;
      case 2:
        return Icons.payment;
      case 3:
        return Icons.history;
      default:
        return Icons.history;
    }
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return 'Check-ins';
      case 1:
        return 'Bookings';
      case 2:
        return 'Payments';
      case 3:
        return 'All';
      default:
        return 'All';
    }
  }
}

class HistoryTabHelper {
  static HistoryType? getHistoryTypeForTab(int index) {
    switch (index) {
      case 0:
        return HistoryType.checkIn;
      case 1:
        return HistoryType.booking;
      case 2:
        return HistoryType.payment;
      case 3:
        return null; // All types
      default:
        return null;
    }
  }

  static IconData getIconForType(HistoryType? type) {
    if (type == null) return Icons.history;

    switch (type) {
      case HistoryType.checkIn:
        return Icons.qr_code_scanner;
      case HistoryType.booking:
        return Icons.event_seat;
      case HistoryType.payment:
        return Icons.payment;
    }
  }

  static String getEmptyMessageForTab(int index) {
    switch (index) {
      case 0:
        return 'Start scanning QR codes to build your check-in history!';
      case 1:
        return 'Book your first event to see your booking history!';
      case 2:
        return 'Make your first payment to see your payment history!';
      case 3:
        return 'No activity yet. Start using the app to build your history!';
      default:
        return 'No activity yet. Start using the app to build your history!';
    }
  }
}
