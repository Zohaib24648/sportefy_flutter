import 'package:equatable/equatable.dart';

/// Enum for different types of history items
enum HistoryType {
  checkIn('check_in', 'Check-in'),
  booking('booking', 'Booking'),
  payment('payment', 'Payment');

  const HistoryType(this.value, this.displayName);
  final String value;
  final String displayName;

  static HistoryType fromValue(String value) {
    return HistoryType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => HistoryType.checkIn,
    );
  }
}

/// Enum for history item status
enum HistoryStatus {
  pending('pending', 'Pending'),
  success('success', 'Success'),
  failed('failed', 'Failed'),
  cancelled('cancelled', 'Cancelled'),
  refunded('refunded', 'Refunded');

  const HistoryStatus(this.value, this.displayName);
  final String value;
  final String displayName;

  static HistoryStatus fromValue(String value) {
    return HistoryStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => HistoryStatus.pending,
    );
  }
}

/// Base model for history items
class HistoryItem extends Equatable {
  final String id;
  final String userId;
  final HistoryType type;
  final HistoryStatus status;
  final String title;
  final String? description;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isSynced;

  const HistoryItem({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.title,
    this.description,
    required this.metadata,
    required this.createdAt,
    this.updatedAt,
    this.isSynced = false,
  });

  HistoryItem copyWith({
    String? id,
    String? userId,
    HistoryType? type,
    HistoryStatus? status,
    String? title,
    String? description,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.value,
      'status': status.value,
      'title': title,
      'description': description,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      userId: json['userId'],
      type: HistoryType.fromValue(json['type']),
      status: HistoryStatus.fromValue(json['status']),
      title: json['title'],
      description: json['description'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      isSynced: json['isSynced'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    status,
    title,
    description,
    metadata,
    createdAt,
    updatedAt,
    isSynced,
  ];
}

/// Factory class for creating specific history items
class HistoryItemFactory {
  static HistoryItem createCheckInItem({
    required String id,
    required String userId,
    required String eventName,
    required String qrData,
    required DateTime checkInTime,
    HistoryStatus status = HistoryStatus.success,
  }) {
    return HistoryItem(
      id: id,
      userId: userId,
      type: HistoryType.checkIn,
      status: status,
      title: eventName,
      description: 'Checked in to $eventName',
      metadata: {
        'qrData': qrData,
        'eventName': eventName,
        'checkInTime': checkInTime.toIso8601String(),
      },
      createdAt: checkInTime,
    );
  }

  static HistoryItem createBookingItem({
    required String id,
    required String userId,
    required String eventName,
    required String bookingReference,
    required DateTime bookingTime,
    required double amount,
    HistoryStatus status = HistoryStatus.success,
  }) {
    return HistoryItem(
      id: id,
      userId: userId,
      type: HistoryType.booking,
      status: status,
      title: eventName,
      description: 'Booked $eventName',
      metadata: {
        'eventName': eventName,
        'bookingReference': bookingReference,
        'amount': amount,
        'bookingTime': bookingTime.toIso8601String(),
      },
      createdAt: bookingTime,
    );
  }

  static HistoryItem createPaymentItem({
    required String id,
    required String userId,
    required String description,
    required double amount,
    required String paymentMethod,
    required DateTime paymentTime,
    HistoryStatus status = HistoryStatus.success,
  }) {
    return HistoryItem(
      id: id,
      userId: userId,
      type: HistoryType.payment,
      status: status,
      title: 'Payment: $description',
      description:
          'Payment of \$${amount.toStringAsFixed(2)} via $paymentMethod',
      metadata: {
        'amount': amount,
        'paymentMethod': paymentMethod,
        'paymentTime': paymentTime.toIso8601String(),
      },
      createdAt: paymentTime,
    );
  }
}
