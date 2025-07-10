// lib/core/utils/qr_code_utils.dart
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility class for processing different types of QR codes
class QRCodeUtils {
  /// Determines the type of QR code based on its content
  static QRCodeType getQRCodeType(String data) {
    if (data.isEmpty) return QRCodeType.unknown;

    // URL detection
    if (data.startsWith('http://') ||
        data.startsWith('https://') ||
        data.startsWith('www.')) {
      return QRCodeType.url;
    }

    // Email detection
    if (data.startsWith('mailto:')) {
      return QRCodeType.email;
    }

    // Phone number detection
    if (data.startsWith('tel:') || _isPhoneNumber(data)) {
      return QRCodeType.phone;
    }

    // WiFi QR code detection
    if (data.startsWith('WIFI:')) {
      return QRCodeType.wifi;
    }

    // vCard (contact) detection
    if (data.startsWith('BEGIN:VCARD')) {
      return QRCodeType.contact;
    }

    // SMS detection
    if (data.startsWith('sms:') || data.startsWith('SMS:')) {
      return QRCodeType.sms;
    }

    // Venue/Event check-in codes (custom format)
    if (data.startsWith('VENUE:') ||
        data.startsWith('EVENT:') ||
        data.startsWith('CHECKIN:')) {
      return QRCodeType.checkIn;
    }

    // Geolocation detection
    if (data.startsWith('geo:')) {
      return QRCodeType.location;
    }

    // App-specific codes
    if (data.startsWith('SPORTEFY:')) {
      return QRCodeType.appSpecific;
    }

    return QRCodeType.text;
  }

  /// Processes QR code data based on its type
  static Future<QRProcessResult> processQRCode(String data) async {
    final type = getQRCodeType(data);

    try {
      switch (type) {
        case QRCodeType.url:
          return await _processURL(data);
        case QRCodeType.email:
          return await _processEmail(data);
        case QRCodeType.phone:
          return await _processPhone(data);
        case QRCodeType.wifi:
          return _processWiFi(data);
        case QRCodeType.contact:
          return _processContact(data);
        case QRCodeType.sms:
          return await _processSMS(data);
        case QRCodeType.checkIn:
          return _processCheckIn(data);
        case QRCodeType.location:
          return await _processLocation(data);
        case QRCodeType.appSpecific:
          return _processAppSpecific(data);
        case QRCodeType.text:
        default:
          return QRProcessResult(
            success: true,
            message: 'Text content scanned successfully',
            action: 'Text copied to clipboard',
            data: data,
          );
      }
    } catch (e) {
      return QRProcessResult(
        success: false,
        message: 'Error processing QR code',
        action: 'Please try again',
        data: data,
        error: e.toString(),
      );
    }
  }

  // Private helper methods

  static bool _isPhoneNumber(String data) {
    // Simple phone number regex
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(data);
  }

  static Future<QRProcessResult> _processURL(String data) async {
    try {
      final uri = Uri.parse(data);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return QRProcessResult(
          success: true,
          message: 'Opening website',
          action: 'URL launched successfully',
          data: data,
        );
      } else {
        // Copy to clipboard if can't launch
        await Clipboard.setData(ClipboardData(text: data));
        return QRProcessResult(
          success: true,
          message: 'URL copied to clipboard',
          action: 'Cannot open URL automatically',
          data: data,
        );
      }
    } catch (e) {
      return QRProcessResult(
        success: false,
        message: 'Invalid URL format',
        action: 'Please check the QR code',
        data: data,
        error: e.toString(),
      );
    }
  }

  static Future<QRProcessResult> _processEmail(String data) async {
    try {
      final uri = Uri.parse(data);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return QRProcessResult(
          success: true,
          message: 'Opening email app',
          action: 'Email composer opened',
          data: data,
        );
      } else {
        await Clipboard.setData(
          ClipboardData(text: data.replaceFirst('mailto:', '')),
        );
        return QRProcessResult(
          success: true,
          message: 'Email copied to clipboard',
          action: 'Cannot open email app automatically',
          data: data,
        );
      }
    } catch (e) {
      return QRProcessResult(
        success: false,
        message: 'Invalid email format',
        action: 'Please check the QR code',
        data: data,
        error: e.toString(),
      );
    }
  }

  static Future<QRProcessResult> _processPhone(String data) async {
    try {
      String phoneNumber = data.startsWith('tel:') ? data : 'tel:$data';
      final uri = Uri.parse(phoneNumber);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return QRProcessResult(
          success: true,
          message: 'Opening phone app',
          action: 'Phone dialer opened',
          data: data,
        );
      } else {
        await Clipboard.setData(
          ClipboardData(text: data.replaceFirst('tel:', '')),
        );
        return QRProcessResult(
          success: true,
          message: 'Phone number copied',
          action: 'Cannot open phone app automatically',
          data: data,
        );
      }
    } catch (e) {
      return QRProcessResult(
        success: false,
        message: 'Invalid phone number',
        action: 'Please check the QR code',
        data: data,
        error: e.toString(),
      );
    }
  }

  static QRProcessResult _processWiFi(String data) {
    // Parse WiFi QR format: WIFI:T:WPA;S:NetworkName;P:Password;H:false;;
    try {
      final wifiData = _parseWiFiData(data);
      return QRProcessResult(
        success: true,
        message: 'WiFi network detected',
        action: 'Network details available',
        data: data,
        metadata: wifiData,
      );
    } catch (e) {
      return QRProcessResult(
        success: false,
        message: 'Invalid WiFi QR format',
        action: 'Please check the QR code',
        data: data,
        error: e.toString(),
      );
    }
  }

  static QRProcessResult _processContact(String data) {
    try {
      final contactData = _parseVCard(data);
      return QRProcessResult(
        success: true,
        message: 'Contact information detected',
        action: 'Contact details available',
        data: data,
        metadata: contactData,
      );
    } catch (e) {
      return QRProcessResult(
        success: false,
        message: 'Invalid contact format',
        action: 'Please check the QR code',
        data: data,
        error: e.toString(),
      );
    }
  }

  static Future<QRProcessResult> _processSMS(String data) async {
    try {
      final uri = Uri.parse(data);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return QRProcessResult(
          success: true,
          message: 'Opening SMS app',
          action: 'SMS composer opened',
          data: data,
        );
      } else {
        return QRProcessResult(
          success: true,
          message: 'SMS data detected',
          action: 'Cannot open SMS app automatically',
          data: data,
        );
      }
    } catch (e) {
      return QRProcessResult(
        success: false,
        message: 'Invalid SMS format',
        action: 'Please check the QR code',
        data: data,
        error: e.toString(),
      );
    }
  }

  static QRProcessResult _processCheckIn(String data) {
    // Custom processing for venue/event check-ins
    try {
      final checkInData = _parseCheckInData(data);
      return QRProcessResult(
        success: true,
        message: 'Check-in code detected',
        action: 'Processing check-in...',
        data: data,
        metadata: checkInData,
      );
    } catch (e) {
      return QRProcessResult(
        success: false,
        message: 'Invalid check-in code',
        action: 'Please contact venue staff',
        data: data,
        error: e.toString(),
      );
    }
  }

  static Future<QRProcessResult> _processLocation(String data) async {
    try {
      // Parse geo:latitude,longitude format
      final locationData = _parseLocationData(data);
      final mapsUrl =
          'https://maps.google.com/?q=${locationData['lat']},${locationData['lng']}';
      final uri = Uri.parse(mapsUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return QRProcessResult(
          success: true,
          message: 'Opening location in maps',
          action: 'Maps app launched',
          data: data,
          metadata: locationData,
        );
      } else {
        return QRProcessResult(
          success: true,
          message: 'Location detected',
          action: 'Cannot open maps automatically',
          data: data,
          metadata: locationData,
        );
      }
    } catch (e) {
      return QRProcessResult(
        success: false,
        message: 'Invalid location format',
        action: 'Please check the QR code',
        data: data,
        error: e.toString(),
      );
    }
  }

  static QRProcessResult _processAppSpecific(String data) {
    // Process app-specific QR codes
    try {
      final appData = _parseAppSpecificData(data);
      return QRProcessResult(
        success: true,
        message: 'Sportefy code detected',
        action: 'Processing app data...',
        data: data,
        metadata: appData,
      );
    } catch (e) {
      return QRProcessResult(
        success: false,
        message: 'Invalid app code format',
        action: 'Please update your app',
        data: data,
        error: e.toString(),
      );
    }
  }

  // Parsing helper methods

  static Map<String, String> _parseWiFiData(String data) {
    final parts = data.substring(5).split(';'); // Remove 'WIFI:' prefix
    final result = <String, String>{};

    for (final part in parts) {
      if (part.isNotEmpty && part.contains(':')) {
        final keyValue = part.split(':');
        if (keyValue.length >= 2) {
          final key = keyValue[0];
          final value = keyValue.sublist(1).join(':');

          switch (key) {
            case 'T':
              result['security'] = value;
              break;
            case 'S':
              result['ssid'] = value;
              break;
            case 'P':
              result['password'] = value;
              break;
            case 'H':
              result['hidden'] = value;
              break;
          }
        }
      }
    }

    return result;
  }

  static Map<String, String> _parseVCard(String data) {
    final lines = data.split('\n');
    final result = <String, String>{};

    for (final line in lines) {
      if (line.contains(':')) {
        final parts = line.split(':');
        if (parts.length >= 2) {
          final key = parts[0].toUpperCase();
          final value = parts.sublist(1).join(':');

          switch (key) {
            case 'FN':
              result['name'] = value;
              break;
            case 'TEL':
              result['phone'] = value;
              break;
            case 'EMAIL':
              result['email'] = value;
              break;
            case 'ORG':
              result['organization'] = value;
              break;
            case 'TITLE':
              result['title'] = value;
              break;
          }
        }
      }
    }

    return result;
  }

  static Map<String, String> _parseCheckInData(String data) {
    final parts = data.split(':');
    final result = <String, String>{};

    if (parts.length >= 2) {
      result['type'] = parts[0].toLowerCase();

      // Parse additional data if present
      if (parts.length > 2) {
        final additionalData = parts.sublist(2).join(':').split('|');
        for (final item in additionalData) {
          if (item.contains('=')) {
            final keyValue = item.split('=');
            if (keyValue.length == 2) {
              result[keyValue[0]] = keyValue[1];
            }
          }
        }
      }

      result['id'] = parts[1];
    }

    return result;
  }

  static Map<String, String> _parseLocationData(String data) {
    // Parse geo:latitude,longitude or geo:latitude,longitude,altitude
    final coordinates = data.substring(4).split(','); // Remove 'geo:' prefix
    final result = <String, String>{};

    if (coordinates.length >= 2) {
      result['lat'] = coordinates[0];
      result['lng'] = coordinates[1];
      if (coordinates.length >= 3) {
        result['alt'] = coordinates[2];
      }
    }

    return result;
  }

  static Map<String, String> _parseAppSpecificData(String data) {
    // Parse SPORTEFY:action|param1=value1|param2=value2
    final parts = data.substring(9).split('|'); // Remove 'SPORTEFY:' prefix
    final result = <String, String>{};

    if (parts.isNotEmpty) {
      result['action'] = parts[0];

      for (int i = 1; i < parts.length; i++) {
        if (parts[i].contains('=')) {
          final keyValue = parts[i].split('=');
          if (keyValue.length == 2) {
            result[keyValue[0]] = keyValue[1];
          }
        }
      }
    }

    return result;
  }
}

/// Enum for different types of QR codes
enum QRCodeType {
  url,
  email,
  phone,
  wifi,
  contact,
  sms,
  checkIn,
  location,
  appSpecific,
  text,
  unknown,
}

/// Result class for QR code processing
class QRProcessResult {
  final bool success;
  final String message;
  final String action;
  final String data;
  final Map<String, String>? metadata;
  final String? error;

  const QRProcessResult({
    required this.success,
    required this.message,
    required this.action,
    required this.data,
    this.metadata,
    this.error,
  });

  @override
  String toString() {
    return 'QRProcessResult(success: $success, message: $message, action: $action)';
  }
}
