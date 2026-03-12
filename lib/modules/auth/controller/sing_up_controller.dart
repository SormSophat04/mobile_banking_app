import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingUpController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isFormValid = false;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(_updateFormState);
    phoneController.addListener(_updateFormState);
    passwordController.addListener(_updateFormState);
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _updateFormState() {
    final bool next = nameController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;

    if (next != isFormValid) {
      isFormValid = next;
      update();
    }
  }
}
