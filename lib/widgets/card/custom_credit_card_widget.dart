import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';

class CustomCreditCardWidget extends StatelessWidget {
  final String userName;
  final String cardNumber;
  final String balance;
  final String? cardType;
  final bool isSelected;
  final VoidCallback? onTap;
  final double marginTop;

  const CustomCreditCardWidget({
    super.key,
    this.userName = 'Ronaldo',
    this.cardNumber = '1234 5678 9012 3456',
    this.balance = '\$2100.00',
    this.cardType,
    this.isSelected = false,
    this.onTap,
    this.marginTop = 24,
  });

  @override
  Widget build(BuildContext context) {
    final cardBackground = _resolveCardBackground(cardType);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        height: 170.h,
        padding: EdgeInsets.all(16.dg),
        margin: EdgeInsets.only(top: marginTop.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.22)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: isSelected ? 14 : 8,
              offset: const Offset(0, 4),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(cardBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    userName,
                    style: AppTextStyles.title3.copyWith(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (cardType != null && cardType!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      cardType!.replaceAll('_', ' '),
                      style: AppTextStyles.caption1.copyWith(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                if (isSelected) ...[
                  SizedBox(width: 8.w),
                  Icon(Icons.check_circle, color: Colors.white, size: 18.sp),
                ],
              ],
            ),
            SizedBox(height: 18.h),
            Text(
              'Mobile Banking',
              style: AppTextStyles.body3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              cardNumber,
              style: AppTextStyles.body1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              balance,
              style: AppTextStyles.title3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveCardBackground(String? type) {
    final normalized = type?.trim().toUpperCase() ?? '';
    if (normalized == 'MASTER_CARD' ||
        normalized == 'MASTERCARD' ||
        normalized == 'MASTER') {
      return AppAssets.masterCard;
    }
    if (normalized == 'VISA_CARD' || normalized == 'VISA') {
      return AppAssets.visaCard;
    }
    return AppAssets.visaCard;
  }
}
