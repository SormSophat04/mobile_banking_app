import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isFormValid = false;

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
}
