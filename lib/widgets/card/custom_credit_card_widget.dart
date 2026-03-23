import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';

class CustomCreditCardWidget extends StatelessWidget {
  final String userName;
  final String cardNumber;
  final String balance;

  const CustomCreditCardWidget({
    super.key,
    this.userName = 'Ronaldo',
    this.cardNumber = '1234 5678 9012 3456',
    this.balance = '\$2100.00',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160.h,
      padding: EdgeInsets.all(16.dg),
      margin: EdgeInsets.only(top: 24.dg),
      decoration: BoxDecoration(
        // color: Colors.yellowAccent,
        image: DecorationImage(image: AssetImage(AppAssets.visaCard)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            style: AppTextStyles.title1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Mobile Banking',
            style: AppTextStyles.body1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            cardNumber,
            style: AppTextStyles.body1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            balance,
            style: AppTextStyles.title1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
