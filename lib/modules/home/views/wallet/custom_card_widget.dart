import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';

class CustomCardWidget extends StatelessWidget {
  CustomCardWidget({super.key});

  final List<String> images = [
    AppAssets.blueCard,
    AppAssets.yellowCard,
    // AppAssets.blueCard,
    // AppAssets.yellowCard,
    // AppAssets.blueCard,
    // AppAssets.yellowCard,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22.dm),
      child: Stack(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: images.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.only(bottom: 16.dm),
              child: Image.asset(images[index], fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 0,
            left: 0,
            child: CustomButtonPrimaryActive(label: 'Add Card'),
          ),
        ],
      ),
    );
  }
}
