import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';

class CreditCardController extends GetxController {
  final GlobalKey pointerKey = GlobalKey();

  final List cardImages = [
    AppAssets.blueCard,
    AppAssets.yellowCard,
    AppAssets.blueCard,
    AppAssets.yellowCard,
  ];

  var currentIndex = 0.obs;
  var dragOverMap = false.obs;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void checkDrag(
    Offset position,
    bool up, {
    ValueChanged<bool>? onInteractionChanged,
  }) {
    final context = pointerKey.currentContext;
    if (context == null) {
      return;
    }

    if (!up) {
      final renderObject = context.findRenderObject();
      if (renderObject is! RenderBox) {
        return;
      }

      final boxOffset = renderObject.localToGlobal(Offset.zero);
      if (position.dy > boxOffset.dy &&
          position.dy < boxOffset.dy + renderObject.size.height) {
        setDragOverMap(true);
        onInteractionChanged?.call(true);
      }
    } else {
      setDragOverMap(false);
      onInteractionChanged?.call(false);
    }
  }

  void setDragOverMap(bool value) {
    dragOverMap.value = value;
    update();
  }
}
