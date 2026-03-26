import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/network/models/khqr_model.dart';
import 'package:mobile_banking_app/core/network/models/account_model.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

class KhqrController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isSaving = false.obs;
  bool get isSaving => _isSaving.value;

  final _khqrData = Rxn<KhqrModel>();
  KhqrModel? get khqrData => _khqrData.value;

  final _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  final ScreenshotController screenshotController = ScreenshotController();
  final amountController = TextEditingController();
  final bakongIdController = TextEditingController(text: 'sophat_sorm@aclb'); // Default as per example

  late AccountModel account;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is AccountModel) {
      account = Get.arguments;
      generateKhqr();
    } else {
      _errorMessage.value = 'Invalid account data';
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    bakongIdController.dispose();
    super.onClose();
  }

  Future<void> generateKhqr() async {
    if (account.accountId == null) return;
    
    _isLoading.value = true;
    _errorMessage.value = '';
    
    try {
      final double? amount = double.tryParse(amountController.text);
      final String? bakongId = bakongIdController.text.isNotEmpty ? bakongIdController.text : null;
      
      print('Generating KHQR for account ${account.accountId} with amount: $amount, bakongId: $bakongId');
      
      final response = await _apiClient.getKhqr(
        account.accountId.toString(),
        amount: amount,
        bakongAccountId: bakongId,
      );
      
      print('KHQR Response Status: ${response.statusCode}');
      print('KHQR Response Body: ${response.body}');

      if (response.isOk && response.body != null) {
        _khqrData.value = KhqrModel.fromJson(response.body);
      } else {
        _errorMessage.value = response.statusText ?? 'Failed to generate KHQR (${response.statusCode})';
      }
    } catch (e) {
      print('Error generating KHQR: $e');
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> saveQrCode() async {
    try {
      _isSaving.value = true;
      print('Saving QR code...');
      
      // Check permissions based on Android version
      bool hasPermission = false;
      final photosStatus = await Permission.photos.request();
      final storageStatus = await Permission.storage.request();
      print('Photos permission: $photosStatus, Storage permission: $storageStatus');

      if (photosStatus.isGranted || storageStatus.isGranted || photosStatus.isLimited) {
        hasPermission = true;
      }

      if (hasPermission) {
        print('Permission granted, capturing screenshot...');
        // Wait a bit to ensure UI reflects current state
        await Future.delayed(const Duration(milliseconds: 200));
        
        final Uint8List? imageBytes = await screenshotController.capture(
          delay: const Duration(milliseconds: 100),
          pixelRatio: 3.0,
        );
        
        if (imageBytes != null) {
          print('Screenshot captured, saving to gallery via gal...');
          await Gal.putImageBytes(
            imageBytes,
            name: "KHQR_${account.accountNumber}_${DateTime.now().millisecondsSinceEpoch}",
          );
          
          Get.snackbar('Success', 'KHQR saved to gallery', snackPosition: SnackPosition.BOTTOM);
        } else {
          print('Failed to capture image');
          Get.snackbar('Error', 'Failed to capture QR code image', snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        print('Permission denied');
        Get.snackbar('Permission Denied', 'Please allow gallery access in settings', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error in saveQrCode: $e');
      Get.snackbar('Error', 'An error occurred while saving: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      _isSaving.value = false;
    }
  }
}
