import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardAndAccountController extends GetxController {
  late final PageController pageController;
  int currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onTabSelected(int index) {
    if (index == currentIndex) return;
    currentIndex = index;
    update();
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void onPageChanged(int index) {
    if (index == currentIndex) return;
    currentIndex = index;
    update();
  }
}
