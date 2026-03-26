import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/transfer_controller.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

class TransferScanQrView extends StatefulWidget {
  const TransferScanQrView({super.key});

  @override
  State<TransferScanQrView> createState() => _TransferScanQrViewState();
}

class _TransferScanQrViewState extends State<TransferScanQrView> {
  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: true,
    detectionSpeed: DetectionSpeed.normal,
    formats: const [BarcodeFormat.qrCode],
  );
  bool _isHandlingResult = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isHandlingResult) return;
    
    final scannedValue = capture.barcodes
        .map((barcode) => barcode.rawValue?.trim() ?? barcode.displayValue?.trim() ?? '')
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');

    if (scannedValue.isEmpty) return;

    _processPayload(scannedValue);
  }

  void _processPayload(String payload) {
    _isHandlingResult = true;
    
    final arguments = Get.arguments as Map<String, dynamic>?;
    final bool fromHome = arguments?['fromHome'] ?? false;

    if (fromHome) {
      Get.offNamed(AppRoutes.QR_PAYMENT, arguments: payload);
    } else {
      final transferController = Get.find<TransferController>();
      final isApplied = transferController.applyScannedQr(payload);

      if (isApplied) {
        Get.back();
        Get.snackbar('Scanned', 'Account number has been filled automatically');
      } else {
        _isHandlingResult = false;
        Get.snackbar('Invalid QR', 'No valid account number found in this QR');
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image == null) return;
    
    _isHandlingResult = true;
    final BarcodeCapture? capture = await _scannerController.analyzeImage(image.path);
    
    if (capture == null || capture.barcodes.isEmpty) {
      _isHandlingResult = false;
      Get.snackbar('No QR Found', 'Could not detect a QR code in the selected image');
      return;
    }

    final scannedValue = capture.barcodes
        .map((barcode) => barcode.rawValue?.trim() ?? barcode.displayValue?.trim() ?? '')
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');

    if (scannedValue.isEmpty) {
      _isHandlingResult = false;
      Get.snackbar('No QR Found', 'Could not detect a QR code in the selected image');
      return;
    }

    _processPayload(scannedValue); // Call _processPayload for gallery image
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Pay QR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: _scannerController, onDetect: _onDetect),
          _buildOverlay(),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 250.w,
          height: 250.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.white, width: 3),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 34.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                'Align QR inside the frame to fill receiver account number.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body2.copyWith(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: _scannerController.toggleTorch,
                  icon: ValueListenableBuilder<MobileScannerState>(
                    valueListenable: _scannerController,
                    builder: (_, state, _) {
                      return Icon(
                        state.torchState == TorchState.on
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                      );
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                IconButton.filled(
                  onPressed: _scannerController.switchCamera,
                  icon: const Icon(Icons.flip_camera_android_rounded),
                ),
                SizedBox(width: 10.w),
                IconButton.filled(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.image_rounded),
                  style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
