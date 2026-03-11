import 'package:card_slider/card_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/modules/home/controllers/credit_card_controller.dart';

class CustomCreditCard extends StatelessWidget {
  const CustomCreditCard({super.key, this.onInteractionChanged});

  final ValueChanged<bool>? onInteractionChanged;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditCardController>(
      builder: (controller) {
        List<Widget> valuesWidget = [];
        for (int i = 0; i < controller.cardImages.length; i++) {
          valuesWidget.add(
            ClipRRect(
              borderRadius: BorderRadius.circular(22.0),
              child: Image.asset(controller.cardImages[i]),
            ),
          );
        }

        return Listener(
          onPointerUp: (ev) {
            controller.checkDrag(
              ev.position,
              true,
              onInteractionChanged: onInteractionChanged,
            );
          },
          onPointerDown: (ev) {
            controller.checkDrag(
              ev.position,
              false,
              onInteractionChanged: onInteractionChanged,
            );
          },
          onPointerCancel: (ev) {
            controller.checkDrag(
              ev.position,
              true,
              onInteractionChanged: onInteractionChanged,
            );
          },
          child: SizedBox(
            height: 250.h,
            child: ListView(
              shrinkWrap: true,
              physics: controller.dragOverMap.value
                  ? const NeverScrollableScrollPhysics()
                  : const ScrollPhysics(),
              children: [
                SizedBox(
                  height: 250.h,
                  width: double.infinity,
                  child: CardSlider(
                    key: controller.pointerKey,
                    cards: valuesWidget,
                    slideChanged: (index) {
                      controller.onPageChanged(index);
                    },
                    bottomOffset: 0.002,
                    cardHeight: 0.65,
                    cardWidth: 0.88,
                    containerHeight: 250,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
