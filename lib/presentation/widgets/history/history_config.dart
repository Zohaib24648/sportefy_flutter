import 'package:flutter/material.dart';
import '../../../data/model/history_item.dart';

/// Configuration class for history-related UI settings
class HistoryConfig {
  // Colors
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color pendingColor = Colors.orange;
  static const Color cancelledColor = Colors.grey;
  static const Color refundedColor = Colors.blue;
  static const Color unsyncedColor = Colors.orange;
  static const Color syncedColor = Colors.green;

  // Sizes
  static const double itemTileHeight = 80.0;
  static const double iconSize = 24.0;
  static const double smallIconSize = 16.0;
  static const double containerSize = 40.0;
  static const double borderRadius = 8.0;

  // Spacing
  static const EdgeInsets listPadding = EdgeInsets.all(16);
  static const EdgeInsets tilePadding = EdgeInsets.only(bottom: 8);
  static const EdgeInsets metadataPadding = EdgeInsets.only(top: 4);
  static const EdgeInsets badgePadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 2,
  );

  // Text styles
  static const TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold);
  static const TextStyle descriptionStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
  static const TextStyle timestampStyle = TextStyle(fontSize: 12);
  static const TextStyle metadataStyle = TextStyle(
    fontSize: 10,
    color: Colors.grey,
  );
  static const TextStyle badgeStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Helper methods
  static Color getStatusColor(HistoryStatus status) {
    switch (status) {
      case HistoryStatus.success:
        return successColor;
      case HistoryStatus.failed:
        return errorColor;
      case HistoryStatus.pending:
        return pendingColor;
      case HistoryStatus.cancelled:
        return cancelledColor;
      case HistoryStatus.refunded:
        return refundedColor;
    }
  }

  static IconData getStatusIcon(HistoryStatus status) {
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

  static IconData getTypeIcon(HistoryType type) {
    switch (type) {
      case HistoryType.checkIn:
        return Icons.qr_code_scanner;
      case HistoryType.booking:
        return Icons.event_seat;
      case HistoryType.payment:
        return Icons.payment;
    }
  }

  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  // Tab configuration
  static const List<String> tabTitles = [
    'Check-ins',
    'Bookings',
    'Payments',
    'All',
  ];
  static const List<IconData> tabIcons = [
    Icons.qr_code_scanner,
    Icons.event_seat,
    Icons.payment,
    Icons.history,
  ];

  static const List<String> emptyMessages = [
    'Start scanning QR codes to build your check-in history!',
    'Book your first event to see your booking history!',
    'Make your first payment to see your payment history!',
    'No activity yet. Start using the app to build your history!',
  ];

  // Validation
  static bool isValidTabIndex(int index) {
    return index >= 0 && index < tabTitles.length;
  }

  static HistoryType? getHistoryTypeForTab(int index) {
    if (!isValidTabIndex(index)) return null;

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
}
