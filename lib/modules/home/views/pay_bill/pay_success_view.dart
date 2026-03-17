import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';

class PaySuccessView extends StatelessWidget {
  const PaySuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.dg),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100.h),
              Image.asset(AppAssets.imageIll2),
              SizedBox(height: 30.h),
              CustomButtonPrimaryActive(label: 'Confirm'),
              CustomButtonPrimaryActive(label: 'Confirm'),
            ],
          ),
        ),
      ),
    );
  }
}
