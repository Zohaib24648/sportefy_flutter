import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

part 'qr_event.dart';
part 'qr_state.dart';

@injectable
class QrBloc extends Bloc<QrEvent, QrState> {
  MobileScannerController? _cameraController;

  QrBloc() : super(QrInitial()) {
    on<QrInitializeCamera>(_onInitializeCamera);
    on<QrDisposeCamera>(_onDisposeCamera);
    on<QrCodeDetected>(_onQrCodeDetected);
    on<QrToggleFlash>(_onToggleFlash);
    on<QrResetScanning>(_onResetScanning);
    on<QrScanningToggled>(_onScanningToggled);
  }

  Future<void> _onInitializeCamera(
    QrInitializeCamera event,
    Emitter<QrState> emit,
  ) async {
    try {
      emit(QrLoading());

      _cameraController = MobileScannerController();

      emit(
        QrCameraReady(
          controller: _cameraController!,
          isFlashOn: false,
          isScanning: true,
        ),
      );
    } catch (e) {
      emit(QrError('Failed to initialize camera: ${e.toString()}'));
    }
  }

  Future<void> _onDisposeCamera(
    QrDisposeCamera event,
    Emitter<QrState> emit,
  ) async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
      _cameraController = null;
    }
    emit(QrInitial());
  }

  void _onQrCodeDetected(QrCodeDetected event, Emitter<QrState> emit) {
    if (state is QrCameraReady) {
      final currentState = state as QrCameraReady;
      if (currentState.isScanning) {
        // Stop scanning when QR code is detected
        emit(currentState.copyWith(isScanning: false));
        emit(QrCodeScanned(event.data));
      }
    }
  }

  void _onToggleFlash(QrToggleFlash event, Emitter<QrState> emit) {
    if (state is QrCameraReady) {
      final currentState = state as QrCameraReady;
      final newFlashState = !currentState.isFlashOn;

      _cameraController?.toggleTorch();

      emit(currentState.copyWith(isFlashOn: newFlashState));
    }
  }

  void _onResetScanning(QrResetScanning event, Emitter<QrState> emit) {
    if (state is QrCameraReady) {
      final currentState = state as QrCameraReady;
      emit(currentState.copyWith(isScanning: true));
    } else if (state is QrCodeScanned && _cameraController != null) {
      emit(
        QrCameraReady(
          controller: _cameraController!,
          isFlashOn: false,
          isScanning: true,
        ),
      );
    }
  }

  void _onScanningToggled(QrScanningToggled event, Emitter<QrState> emit) {
    if (state is QrCameraReady) {
      final currentState = state as QrCameraReady;
      emit(currentState.copyWith(isScanning: event.isScanning));
    }
  }

  @override
  Future<void> close() {
    if (_cameraController != null) {
      _cameraController!.dispose();
    }
    return super.close();
  }
}
