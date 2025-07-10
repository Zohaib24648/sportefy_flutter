part of 'qr_bloc.dart';

abstract class QrEvent {}

class QrInitializeCamera extends QrEvent {}

class QrDisposeCamera extends QrEvent {}

class QrCodeDetected extends QrEvent {
  final String data;

  QrCodeDetected(this.data);
}

class QrToggleFlash extends QrEvent {}

class QrResetScanning extends QrEvent {}

class QrScanningToggled extends QrEvent {
  final bool isScanning;

  QrScanningToggled(this.isScanning);
}
