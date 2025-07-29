import 'package:uuid/uuid.dart';
import '../../data/model/history/history_item_dto.dart';

class HistoryExamples {
  static const uuid = Uuid();

  // Create sample check-in history items
  static List<HistoryItem> createSampleCheckInHistory(String userId) {
    return [
      HistoryItemFactory.createCheckInItem(
        id: uuid.v4(),
        userId: userId,
        eventName: 'Basketball Tournament Finals',
        qrData: 'event:basketball-finals|venue:sports-center',
        checkInTime: DateTime.now().subtract(const Duration(hours: 2)),
        status: HistoryStatus.success,
      ),
      HistoryItemFactory.createCheckInItem(
        id: uuid.v4(),
        userId: userId,
        eventName: 'Soccer Practice',
        qrData: 'event:soccer-practice|venue:main-field',
        checkInTime: DateTime.now().subtract(const Duration(days: 1)),
        status: HistoryStatus.success,
      ),
      HistoryItemFactory.createCheckInItem(
        id: uuid.v4(),
        userId: userId,
        eventName: 'Gym Session',
        qrData: 'event:gym-session|venue:fitness-center',
        checkInTime: DateTime.now().subtract(const Duration(days: 2)),
        status: HistoryStatus.failed,
      ),
    ];
  }

  // Create sample booking history items
  static List<HistoryItem> createSampleBookingHistory(String userId) {
    return [
      HistoryItemFactory.createBookingItem(
        id: uuid.v4(),
        userId: userId,
        eventName: 'Tennis Court Booking',
        bookingReference: 'BK-${DateTime.now().millisecondsSinceEpoch}',
        bookingTime: DateTime.now().subtract(const Duration(hours: 4)),
        amount: 45.00,
        status: HistoryStatus.success,
      ),
      HistoryItemFactory.createBookingItem(
        id: uuid.v4(),
        userId: userId,
        eventName: 'Swimming Pool Session',
        bookingReference: 'BK-${DateTime.now().millisecondsSinceEpoch - 1000}',
        bookingTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        amount: 25.00,
        status: HistoryStatus.success,
      ),
      HistoryItemFactory.createBookingItem(
        id: uuid.v4(),
        userId: userId,
        eventName: 'Badminton Court',
        bookingReference: 'BK-${DateTime.now().millisecondsSinceEpoch - 2000}',
        bookingTime: DateTime.now().subtract(const Duration(days: 3)),
        amount: 35.00,
        status: HistoryStatus.cancelled,
      ),
    ];
  }

  // Create sample payment history items
  static List<HistoryItem> createSamplePaymentHistory(String userId) {
    return [
      HistoryItemFactory.createPaymentItem(
        id: uuid.v4(),
        userId: userId,
        description: 'Monthly Gym Membership',
        amount: 99.99,
        paymentMethod: 'Credit Card',
        paymentTime: DateTime.now().subtract(const Duration(days: 5)),
        status: HistoryStatus.success,
      ),
      HistoryItemFactory.createPaymentItem(
        id: uuid.v4(),
        userId: userId,
        description: 'Tennis Court Booking',
        amount: 45.00,
        paymentMethod: 'Apple Pay',
        paymentTime: DateTime.now().subtract(const Duration(days: 7)),
        status: HistoryStatus.success,
      ),
      HistoryItemFactory.createPaymentItem(
        id: uuid.v4(),
        userId: userId,
        description: 'Personal Training Session',
        amount: 150.00,
        paymentMethod: 'Credit Card',
        paymentTime: DateTime.now().subtract(const Duration(days: 10)),
        status: HistoryStatus.refunded,
      ),
    ];
  }

  // Create all sample history items
  static List<HistoryItem> createAllSampleHistory(String userId) {
    return [
      ...createSampleCheckInHistory(userId),
      ...createSampleBookingHistory(userId),
      ...createSamplePaymentHistory(userId),
    ];
  }
}
