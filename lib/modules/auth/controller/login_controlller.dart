import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/services/firebase_messaging_service.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class LoginController extends GetxController {
  final ApiClient apiClient = Get.put(ApiClient());
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isFormValid = false, isLoading = false;

  @override
  void onInit() {
    super.onInit();
    for (var c in [phoneController, passwordController]) { c.addListener(_updateFormState); }
  }

  @override
  void onClose() {
    for (var c in [phoneController, passwordController]) { c.dispose(); }
    super.onClose();
  }

  void _updateFormState() {
    final next = phoneController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty;
    if (next != isFormValid) { isFormValid = next; update(); }
  }

  Future<void> login() async {
    if (!isFormValid) return;
    isLoading = true; update();

    try {
      final res = await apiClient.login(phoneController.text.trim(), passwordController.text.trim());
      if (res.isOk) {
        final data = res.body;
        final token = data['token'] ?? data['access_token'] ?? data['accessToken'] ?? data['jwt'] ?? res.headers?['authorization']?.replaceFirst('Bearer ', '');
        if (token != null) await apiClient.saveToken(token.toString());

        final customer = data['customer'] ?? data['user'] ?? data;
        final id = customer['customerId'] ?? customer['id'] ?? data['id'] ?? data['sub'];
        if (id != null) await apiClient.saveCustomerId(id.toString());

        await _registerDeviceFcmToken();
        Get.offAllNamed(AppRoutes.MAIN_LAYOUT);
      } else {
        Get.snackbar('Error', res.body?['message'] ?? 'Login failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
    } finally {
      isLoading = false; update();
    }
  }

  Future<void> _registerDeviceFcmToken() async {
    try {
      String? token = FirebaseMessagingService.fcmToken ?? await apiClient.getFcmToken() ?? await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;
      FirebaseMessagingService.fcmToken = token;
      await apiClient.saveFcmToken(token);
    } catch (_) {}
  }
}
