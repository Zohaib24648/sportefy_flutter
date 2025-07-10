part of 'qr_bloc.dart';

abstract class QrState {}

class QrInitial extends QrState {}

class QrLoading extends QrState {}

class QrCameraReady extends QrState {
  final MobileScannerController controller;
  final bool isFlashOn;
  final bool isScanning;

  QrCameraReady({
    required this.controller,
    this.isFlashOn = false,
    this.isScanning = true,
  });

  QrCameraReady copyWith({
    MobileScannerController? controller,
    bool? isFlashOn,
    bool? isScanning,
  }) {
    return QrCameraReady(
      controller: controller ?? this.controller,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      isScanning: isScanning ?? this.isScanning,
    );
  }
}

class QrCodeScanned extends QrState {
  final String data;

  QrCodeScanned(this.data);
}

class QrError extends QrState {
  final String error;

  QrError(this.error);
}
