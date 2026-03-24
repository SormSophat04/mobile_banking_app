import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/services/firebase_messaging_service.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class SingUpController extends GetxController {
  final ApiClient apiClient = Get.put(ApiClient());
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isFormValid = false;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_updateFormState);
    emailController.addListener(_updateFormState);
    passwordController.addListener(_updateFormState);
  }

  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _updateFormState() {
    final bool next = phoneController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;

    if (next != isFormValid) {
      isFormValid = next;
      update();
    }
  }

  Future<void> register() async {
    if (!isFormValid) return;
    
    isLoading = true;
    update();

    try {
      final response = await apiClient.register(
        phoneController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (response.isOk) {
        // Success
        final data = response.body;
        final token = data['token'] ?? data['access_token'] ?? data['accessToken'];
        if (token != null) {
          await apiClient.saveToken(token.toString());
        }
        
        final customerId = data['customerId'] ?? data['id'] ?? data['user']?['id'] ?? data['user']?['customerId'];
        if (customerId != null) {
          await apiClient.saveCustomerId(customerId.toString());
        }

        // Register this device token for push notifications.
        await _registerDeviceFcmToken();

        Get.snackbar('Success', 'Registered successfully');
        Get.offAllNamed(AppRoutes.MAIN_LAYOUT);
      } else {
        // Error
        Get.snackbar('Error', response.body?['message'] ?? 'Registration failed');
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
        debugPrint('FCM token unavailable at signup; skipping token registration.');
        return;
      }

      FirebaseMessagingService.fcmToken = token;
      await apiClient.saveFcmToken(token);
    } catch (e) {
      debugPrint('Unable to register FCM token during signup: $e');
    }
  }
}
