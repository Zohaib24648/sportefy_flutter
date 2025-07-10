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
  HistoryType _selectedType = HistoryType.checkIn;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _selectedType = HistoryType.checkIn;
              break;
            case 1:
              _selectedType = HistoryType.booking;
              break;
            case 2:
              _selectedType = HistoryType.payment;
              break;
            case 3:
              // All history
              break;
          }
        });
        _loadHistory();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadHistory() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      if (_tabController.index == 3) {
        // Load all history
        context.read<HistoryBloc>().add(LoadAllHistory(authState.user.id));
      } else {
        // Load history by type
        context.read<HistoryBloc>().add(
          LoadHistoryByType(authState.user.id, _selectedType),
        );
      }
    }
  }

  void _syncHistory() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<HistoryBloc>().add(SyncHistory(authState.user.id));
    }
  }

  void _loadSampleData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final sampleItems = HistoryExamples.createAllSampleHistory(
        authState.user.id,
      );
      for (final item in sampleItems) {
        context.read<HistoryBloc>().add(AddHistoryItem(item));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _loadSampleData,
            tooltip: 'Load sample data',
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _syncHistory,
            tooltip: 'Sync with server',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
            tooltip: 'Refresh',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Check-ins'),
            Tab(text: 'Bookings'),
            Tab(text: 'Payments'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: BlocConsumer<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state is HistoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is HistorySyncSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('History synced successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          // Auto-load history when widget builds
          if (state is HistoryInitial) {
            _loadHistory();
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HistoryLoading || state is HistorySyncing) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state is HistorySyncing ? 'Syncing...' : 'Loading...',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          List<HistoryItem> items = [];
          if (state is HistoryLoaded) {
            items = state.items;
          } else if (state is HistorySyncSuccess) {
            items = state.items;
          }

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getTabIcon(_tabController.index),
                    size: 64,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No ${_getTabTitle(_tabController.index)} Yet',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getEmptyMessage(_tabController.index),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildHistoryList(
                items
                    .where((item) => item.type == HistoryType.checkIn)
                    .toList(),
              ),
              _buildHistoryList(
                items
                    .where((item) => item.type == HistoryType.booking)
                    .toList(),
              ),
              _buildHistoryList(
                items
                    .where((item) => item.type == HistoryType.payment)
                    .toList(),
              ),
              _buildHistoryList(items),
            ],
          );
        },
      ),
    );
  }

  // Helper methods
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
        return 'History';
      default:
        return 'History';
    }
  }

  String _getEmptyMessage(int index) {
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

  Widget _buildHistoryList(List<HistoryItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getStatusColor(item.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(item.type),
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
                  '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year} at ${item.createdAt.hour}:${item.createdAt.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getStatusIcon(item.status),
                  color: _getStatusColor(item.status),
                ),
                const SizedBox(height: 4),
                if (!item.isSynced)
                  const Icon(
                    Icons.sync_disabled,
                    size: 16,
                    color: Colors.orange,
                  ),
              ],
            ),
          ),
        );
      },
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
