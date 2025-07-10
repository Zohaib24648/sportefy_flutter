import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'history_config.dart';

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
    return HistoryTabHelper.tabIcons[index % HistoryTabHelper.tabIcons.length];
  }

  String _getTabTitle(int index) {
    return HistoryTabHelper.tabTitles[index %
        HistoryTabHelper.tabTitles.length];
  }
}
