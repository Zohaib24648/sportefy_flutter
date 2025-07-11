import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gap/gap.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/qr/qr_bloc.dart';
import '../../../bloc/check_in/check_in_bloc.dart';
import '../../../dependency_injection.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../utils/responsive_helper.dart';
import '../../navigation/main_navigation_wrapper.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<QrBloc>()..add(QrInitializeCamera()),
        ),
        BlocProvider(create: (context) => getIt<CheckInBloc>()),
      ],
      child: const QRScreenContent(),
    );
  }
}

class QRScreenContent extends StatelessWidget {
  const QRScreenContent({super.key});

  void _onDetect(BuildContext context, BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        context.read<QrBloc>().add(QrCodeDetected(barcode.rawValue!));
        break;
      }
    }
  }

  void _handleScannedData(BuildContext context, String data) {
    // Vibrate on successful scan
    HapticFeedback.vibrate();

    // Get the current user from AuthBloc (assuming it's available in the widget tree)
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      // Trigger check-in process
      context.read<CheckInBloc>().add(
        CheckInRequested(qrData: data, userId: authState.user.id),
      );
    }

    // Show success dialog
    _showScanResultDialog(context, data);
  }

  void _showScanResultDialog(BuildContext context, String data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CheckInBloc>(),
        child: BlocConsumer<CheckInBloc, CheckInState>(
          listener: (context, state) {
            if (state is CheckInSuccess) {
              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is CheckInError) {
              // Show error snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, checkInState) => AlertDialog(
            backgroundColor: AppColors.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
                const Gap(12),
                Text(
                  'QR Code Scanned',
                  style: AppStyles.heading(context).copyWith(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      20,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scanned Data:',
                  style: AppStyles.bodyText(context).copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Gap(8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.dividerColor),
                  ),
                  child: Text(
                    data,
                    style: AppStyles.textFieldStyle(context).copyWith(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        14,
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                // Check-in status
                if (checkInState is CheckInLoading)
                  const Row(
                    children: [
                      CircularProgressIndicator(),
                      Gap(12),
                      Text('Processing check-in...'),
                    ],
                  )
                else if (checkInState is CheckInSuccess)
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      Gap(12),
                      Expanded(
                        child: Text(
                          'Checked in successfully!',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  )
                else if (checkInState is CheckInError)
                  Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      Gap(12),
                      Expanded(
                        child: Text(
                          'Check-in failed',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            actions: [
              Builder(
                builder: (buttonContext) => TextButton(
                  onPressed: () {
                    Navigator.of(buttonContext).pop();
                    // Use the original context to access QrBloc
                    final qrBloc = BlocProvider.of<QrBloc>(context);
                    qrBloc.add(QrResetScanning());
                  },
                  child: Text('Scan Again', style: AppStyles.linkText(context)),
                ),
              ),
              Builder(
                builder: (buttonContext) => ElevatedButton(
                  onPressed: () {
                    Navigator.of(buttonContext).pop();
                    // Navigate to history screen to show the latest check-in
                    _navigateToHistory(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Confirm', style: AppStyles.buttonText(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHistory(BuildContext context) {
    // Get the current user ID for refreshing history
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.id : null;

    // Navigate back to the main navigation wrapper and switch to history tab (index 4)
    Navigator.of(context).popUntil((route) => route.isFirst);

    // Replace current route with MainNavigationWrapper showing history tab
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainNavigationWrapper(initialIndex: 4),
      ),
    );

    // Add a post-frame callback to refresh the history after navigation
    if (userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // The history will be automatically loaded by the HistoryScreen when it's initialized
        // with the check-in tab selected (index 0)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
        ),
        title: Text(
          'Scan QR Code',
          style: AppStyles.heading(context).copyWith(
            color: Colors.white,
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<QrBloc, QrState>(
            builder: (context, state) {
              if (state is QrCameraReady) {
                return IconButton(
                  onPressed: () {
                    context.read<QrBloc>().add(QrToggleFlash());
                  },
                  icon: Icon(
                    state.isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                    size: 24,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<QrBloc, QrState>(
        listener: (context, state) {
          if (state is QrCodeScanned) {
            _handleScannedData(context, state.data);
          } else if (state is QrError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is QrLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  Gap(16),
                  Text(
                    'Initializing camera...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }

          if (state is QrCameraReady) {
            return Stack(
              children: [
                // Camera View
                MobileScanner(
                  controller: state.controller,
                  onDetect: state.isScanning
                      ? (capture) => _onDetect(context, capture)
                      : null,
                ),

                // Overlay with scanning frame
                Container(
                  decoration: ShapeDecoration(
                    shape: QrScannerOverlayShape(
                      borderColor: AppColors.primaryColor,
                      borderRadius: 16,
                      borderLength: 30,
                      borderWidth: 4,
                      cutOutSize: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                ),

                // Instructions
                Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            24,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          state.isScanning
                              ? 'Point your camera at a QR code to scan it'
                              : 'QR code detected, processing...',
                          style: AppStyles.bodyText(context).copyWith(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              16,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Gap(20),
                      if (state.isScanning)
                        _buildActionButton(
                          context: context,
                          icon: Icons.refresh,
                          label: 'Reset',
                          onTap: () {
                            context.read<QrBloc>().add(QrResetScanning());
                          },
                        ),
                    ],
                  ),
                ),
              ],
            );
          }

          if (state is QrError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 64,
                  ),
                  const Gap(16),
                  Text(
                    'Camera Error',
                    style: AppStyles.heading(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                  const Gap(8),
                  Text(
                    state.error,
                    style: AppStyles.bodyText(
                      context,
                    ).copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<QrBloc>().add(QrInitializeCamera());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const Gap(8),
            Text(
              label,
              style: AppStyles.bodyText(context).copyWith(
                color: Colors.white,
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom overlay shape for QR scanner (keeping the existing implementation)
class QrScannerOverlayShape extends ShapeBorder {
  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final cutOutWidth = cutOutSize < width ? cutOutSize : width - borderWidth;
    final cutOutHeight = cutOutSize < height
        ? cutOutSize
        : height - borderWidth;

    final cutOutRect = Rect.fromLTWH(
      rect.left + (width - cutOutWidth) / 2 + borderWidth / 2,
      rect.top + (height - cutOutHeight) / 2 + borderWidth / 2,
      cutOutWidth - borderWidth,
      cutOutHeight - borderWidth,
    );

    final cutOutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      );

    return Path.combine(
      PathOperation.difference,
      Path()..addRect(rect),
      cutOutPath,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final cutOutWidth = cutOutSize < width ? cutOutSize : width - borderWidth;
    final cutOutHeight = cutOutSize < height
        ? cutOutSize
        : height - borderWidth;

    final cutOutRect = Rect.fromLTWH(
      rect.left + (width - cutOutWidth) / 2 + borderWidth / 2,
      rect.top + (height - cutOutHeight) / 2 + borderWidth / 2,
      cutOutWidth - borderWidth,
      cutOutHeight - borderWidth,
    );

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final backgroundPath = Path()
      ..addRect(rect)
      ..addRRect(
        RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, backgroundPaint);

    // Draw corner borders
    final cornerRadius = borderRadius > 0 ? borderRadius : 0.0;
    final cornerPath = Path();

    // Top-left corner
    cornerPath.moveTo(
      cutOutRect.left - borderWidth / 2,
      cutOutRect.top + borderLength,
    );
    cornerPath.lineTo(
      cutOutRect.left - borderWidth / 2,
      cutOutRect.top + cornerRadius,
    );
    if (cornerRadius > 0) {
      cornerPath.arcToPoint(
        Offset(
          cutOutRect.left + cornerRadius,
          cutOutRect.top - borderWidth / 2,
        ),
        radius: Radius.circular(cornerRadius),
      );
    } else {
      cornerPath.lineTo(cutOutRect.left, cutOutRect.top - borderWidth / 2);
    }
    cornerPath.lineTo(
      cutOutRect.left + borderLength,
      cutOutRect.top - borderWidth / 2,
    );

    // Top-right corner
    cornerPath.moveTo(
      cutOutRect.right - borderLength,
      cutOutRect.top - borderWidth / 2,
    );
    cornerPath.lineTo(
      cutOutRect.right - cornerRadius,
      cutOutRect.top - borderWidth / 2,
    );
    if (cornerRadius > 0) {
      cornerPath.arcToPoint(
        Offset(
          cutOutRect.right + borderWidth / 2,
          cutOutRect.top + cornerRadius,
        ),
        radius: Radius.circular(cornerRadius),
      );
    } else {
      cornerPath.lineTo(cutOutRect.right + borderWidth / 2, cutOutRect.top);
    }
    cornerPath.lineTo(
      cutOutRect.right + borderWidth / 2,
      cutOutRect.top + borderLength,
    );

    // Bottom-right corner
    cornerPath.moveTo(
      cutOutRect.right + borderWidth / 2,
      cutOutRect.bottom - borderLength,
    );
    cornerPath.lineTo(
      cutOutRect.right + borderWidth / 2,
      cutOutRect.bottom - cornerRadius,
    );
    if (cornerRadius > 0) {
      cornerPath.arcToPoint(
        Offset(
          cutOutRect.right - cornerRadius,
          cutOutRect.bottom + borderWidth / 2,
        ),
        radius: Radius.circular(cornerRadius),
      );
    } else {
      cornerPath.lineTo(cutOutRect.right, cutOutRect.bottom + borderWidth / 2);
    }
    cornerPath.lineTo(
      cutOutRect.right - borderLength,
      cutOutRect.bottom + borderWidth / 2,
    );

    // Bottom-left corner
    cornerPath.moveTo(
      cutOutRect.left + borderLength,
      cutOutRect.bottom + borderWidth / 2,
    );
    cornerPath.lineTo(
      cutOutRect.left + cornerRadius,
      cutOutRect.bottom + borderWidth / 2,
    );
    if (cornerRadius > 0) {
      cornerPath.arcToPoint(
        Offset(
          cutOutRect.left - borderWidth / 2,
          cutOutRect.bottom - cornerRadius,
        ),
        radius: Radius.circular(cornerRadius),
      );
    } else {
      cornerPath.lineTo(cutOutRect.left - borderWidth / 2, cutOutRect.bottom);
    }
    cornerPath.lineTo(
      cutOutRect.left - borderWidth / 2,
      cutOutRect.bottom - borderLength,
    );

    canvas.drawPath(cornerPath, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
