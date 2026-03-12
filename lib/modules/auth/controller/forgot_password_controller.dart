import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  bool isFormValid = false;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_updateFormState);
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void _updateFormState() {
    final bool next = phoneController.text.trim().isNotEmpty;
    if (next != isFormValid) {
      isFormValid = next;
      update();
    }
  }
}
