import 'package:flutter/material.dart';
import '../../../core/utils/history_examples.dart';
import '../../../data/model/history_item.dart';
import '../../constants/app_colors.dart';
import '../../widgets/history/history_widgets.dart';

/// Demo screen showing different ways to use the modular history components
class HistoryComponentsDemo extends StatefulWidget {
  const HistoryComponentsDemo({super.key});

  @override
  State<HistoryComponentsDemo> createState() => _HistoryComponentsDemoState();
}

class _HistoryComponentsDemoState extends State<HistoryComponentsDemo> {
  late List<HistoryItem> sampleItems;

  @override
  void initState() {
    super.initState();
    sampleItems = HistoryExamples.createAllSampleHistory('demo-user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Components Demo'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Individual History Item Tiles',
              _buildIndividualTiles(),
            ),
            const SizedBox(height: 24),
            _buildSection('Status Indicators', _buildStatusIndicators()),
            const SizedBox(height: 24),
            _buildSection('Type Icons', _buildTypeIcons()),
            const SizedBox(height: 24),
            _buildSection('Sync Status Indicators', _buildSyncIndicators()),
            const SizedBox(height: 24),
            _buildSection(
              'List View with Different Filters',
              _buildListViews(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildIndividualTiles() {
    return Column(
      children: sampleItems.take(3).map((item) {
        return HistoryItemTile(item: item, onTap: () => _showItemDetails(item));
      }).toList(),
    );
  }

  Widget _buildStatusIndicators() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: HistoryStatus.values.map((status) {
        return Column(
          children: [
            HistoryStatusIndicator(status: status),
            const SizedBox(height: 4),
            Text(status.displayName, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTypeIcons() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: HistoryType.values.map((type) {
        return Column(
          children: [
            HistoryTypeIcon(type: type),
            const SizedBox(height: 4),
            Text(type.displayName, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSyncIndicators() {
    return Row(
      children: [
        Column(
          children: [
            const SyncStatusIndicator(isSynced: true),
            const SizedBox(height: 4),
            Text('Synced', style: const TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(width: 32),
        Column(
          children: [
            const SyncStatusIndicator(isSynced: false),
            const SizedBox(height: 4),
            Text('Not Synced', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildListViews() {
    return Column(
      children: [
        // Check-ins only
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: HistoryListView(
            items: sampleItems
                .where((item) => item.type == HistoryType.checkIn)
                .toList(),
            emptyMessage: 'No check-ins yet',
            emptyIcon: Icons.qr_code_scanner,
            onItemTap: _showItemDetails,
          ),
        ),
        const SizedBox(height: 16),
        // Bookings only
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: HistoryListView(
            items: sampleItems
                .where((item) => item.type == HistoryType.booking)
                .toList(),
            emptyMessage: 'No bookings yet',
            emptyIcon: Icons.event_seat,
            onItemTap: _showItemDetails,
          ),
        ),
        const SizedBox(height: 16),
        // Payments only
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: HistoryListView(
            items: sampleItems
                .where((item) => item.type == HistoryType.payment)
                .toList(),
            emptyMessage: 'No payments yet',
            emptyIcon: Icons.payment,
            onItemTap: _showItemDetails,
          ),
        ),
      ],
    );
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
            Row(
              children: [
                HistoryTypeIcon(type: item.type),
                const SizedBox(width: 8),
                Text(item.type.displayName),
                const Spacer(),
                HistoryStatusIndicator(status: item.status, showLabel: true),
              ],
            ),
            const SizedBox(height: 8),
            if (item.description != null)
              Text('Description: ${item.description}'),
            const SizedBox(height: 8),
            Text('Created: ${item.createdAt}'),
            if (item.metadata.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...item.metadata.entries.map(
                (entry) => Text('${entry.key}: ${entry.value}'),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Sync Status: '),
                SyncStatusIndicator(isSynced: item.isSynced),
                const SizedBox(width: 4),
                Text(item.isSynced ? 'Synced' : 'Not Synced'),
              ],
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
}
