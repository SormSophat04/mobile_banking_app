import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/services/firebase_messaging_service.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class LoginController extends GetxController {
  final ApiClient apiClient = Get.put(ApiClient());
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isFormValid = false;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_updateFormState);
    passwordController.addListener(_updateFormState);
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _updateFormState() {
    final bool next =
        phoneController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;

    if (next != isFormValid) {
      isFormValid = next;
      update();
    }
  }

  Future<void> login() async {
    if (!isFormValid) return;
    
    isLoading = true;
    update();

    try {
      final response = await apiClient.login(
        phoneController.text.trim(),
        passwordController.text.trim(),
      );

      if (response.isOk) {
        // Success
        final data = response.body;
        // Attempt to parse token from various common key names or HTTP headers
        final headerToken = response.headers?['authorization']?.replaceFirst('Bearer ', '');
        final token = data['token'] ?? data['access_token'] ?? data['accessToken'] ?? data['jwt'] ?? headerToken;
        if (token != null) {
          await apiClient.saveToken(token.toString());
        }

        // Save customer ID FIRST (needed by saveFcmToken to link token to account)
        final customerId =
            data['customerId'] ??
            data['id'] ??
            data['customer']?['customerId'] ??
            data['customer']?['id'] ??
            data['user']?['customerId'] ??
            data['user']?['id'];
        if (customerId != null) {
          await apiClient.saveCustomerId(customerId.toString());
        }

        // Register this device token for push notifications.
        await _registerDeviceFcmToken();

        Get.snackbar('Success', 'Logged in successfully');
        Get.offAllNamed(AppRoutes.MAIN_LAYOUT);
      } else {
        // Error
        Get.snackbar('Error', response.body?['message'] ?? 'Login failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> _registerDeviceFcmToken() async {
    try {
      String? token = FirebaseMessagingService.fcmToken;
      token ??= await apiClient.getFcmToken();
      token ??= await FirebaseMessaging.instance.getToken();

      if (token == null || token.isEmpty) {
        debugPrint('FCM token unavailable at login; skipping token registration.');
        return;
      }

      FirebaseMessagingService.fcmToken = token;
      await apiClient.saveFcmToken(token);
    } catch (e) {
      debugPrint('Unable to register FCM token during login: $e');
    }
  }
}
