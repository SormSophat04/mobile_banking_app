import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/modules/home/controllers/home_controller.dart';
import 'package:mobile_banking_app/widgets/card/custom_menu_card.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => GridView.builder(
        itemCount: controller.menuItems.length,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16),
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomMenuCard(
            icon: controller.menuItems[index]['icon'] ?? '',
            label: controller.menuItems[index]['label'] ?? '',
          ),
        ),
      ),
    );
  }
}
