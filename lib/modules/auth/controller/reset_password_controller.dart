import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController newPasswordController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isFormValid = false;

  @override
  void onInit() {
    super.onInit();
    newPasswordController.addListener(_updateFormState);
    confirmPasswordController.addListener(_updateFormState);
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void _updateFormState() {
    final bool next = newPasswordController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim().isNotEmpty;
    if (next != isFormValid) {
      isFormValid = next;
      update();
    }
  }
}
