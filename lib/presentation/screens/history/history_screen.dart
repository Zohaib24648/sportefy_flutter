import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/history/history_bloc.dart';
import '../../../core/utils/history_examples.dart';
import '../../../data/model/history_item.dart';
import '../../../dependency_injection.dart';
import '../../constants/app_colors.dart';
import '../../widgets/history/history_tab_bar.dart';
import '../../widgets/history/history_tab_content.dart';
import '../../widgets/history/history_config.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HistoryBloc>(),
      child: const HistoryScreenContent(),
    );
  }
}

class HistoryScreenContent extends StatefulWidget {
  const HistoryScreenContent({super.key});

  @override
  State<HistoryScreenContent> createState() => _HistoryScreenContentState();
}

class _HistoryScreenContentState extends State<HistoryScreenContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    // Load initial data for the first tab
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHistory());
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  String? get _currentUserId {
    final authState = context.read<AuthBloc>().state;
    return authState is Authenticated ? authState.user.id : null;
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      _loadHistory();
    }
  }

  void _loadHistory() {
    final userId = _currentUserId;
    if (userId == null) return;

    final historyType = HistoryTabHelper.getHistoryTypeForTab(
      _tabController.index,
    );

    if (historyType == null) {
      // Load all history for "All" tab
      context.read<HistoryBloc>().add(LoadAllHistory(userId));
    } else {
      // Load history by specific type
      context.read<HistoryBloc>().add(LoadHistoryByType(userId, historyType));
    }
  }

  void _syncHistory() {
    final userId = _currentUserId;
    if (userId != null) {
      context.read<HistoryBloc>().add(SyncHistory(userId));
    }
  }

  void _loadSampleData() {
    final userId = _currentUserId;
    if (userId == null) return;

    final sampleItems = HistoryExamples.createAllSampleHistory(userId);
    for (final item in sampleItems) {
      context.read<HistoryBloc>().add(AddHistoryItem(item));
    }
  }

  void _onItemTap(HistoryItem item) {
    // Handle item tap - could navigate to detail screen
    _showItemDetails(item);
  }

  void _showItemDetails(HistoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${item.type.displayName}'),
            Text('Status: ${item.status.displayName}'),
            if (item.description != null)
              Text('Description: ${item.description}'),
            Text('Created: ${_formatDateTime(item.createdAt)}'),
            if (item.metadata.isNotEmpty) const SizedBox(height: 8),
            if (item.metadata.isNotEmpty)
              const Text(
                'Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ...item.metadata.entries.map(
              (entry) => Text('${entry.key}: ${entry.value}'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _handleStateChanges(BuildContext context, HistoryState state) {
    final messenger = ScaffoldMessenger.of(context);

    switch (state) {
      case HistoryError():
        messenger.showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: Colors.red),
        );
      case HistorySyncSuccess():
        messenger.showSnackBar(
          const SnackBar(
            content: Text('History synced successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HistoryTabBar(
        controller: _tabController,
        onSyncPressed: _syncHistory,
        onRefreshPressed: _loadHistory,
        onLoadSampleData: _loadSampleData,
      ),
      body: BlocConsumer<HistoryBloc, HistoryState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: List.generate(
              4,
              (index) => HistoryTabContent(
                tabIndex: index,
                state: state,
                onRefresh: _loadHistory,
                onItemTap: _onItemTap,
              ),
            ),
          );
        },
      ),
    );
  }
}
