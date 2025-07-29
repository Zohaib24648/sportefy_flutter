import 'package:flutter/material.dart';
import '../../../data/model/history/history_item_dto.dart';

class HistoryTabHelper {
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
    if (!isValidTabIndex(index)) {
      return 'No activity yet. Start using the app to build your history!';
    }
    return emptyMessages[index];
  }
}
