import 'package:flutter/material.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';

class CustomAddNewCard extends StatelessWidget {
  const CustomAddNewCard({
    super.key,
    this.isSelected = false,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isSelected
        ? AppColors.primaryBackground
        : AppColors.white;
    final Color borderColor = isSelected
        ? AppColors.primary
        : Colors.transparent;
    final Color innerColor = isSelected
        ? AppColors.primary
        : AppColors.primaryBackground;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 120,
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: AppShadows.card,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 18),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: innerColor,
        ),
        child: Image.asset(
          'assets/icons/12.png',
          height: 24,
          width: 24,
          color: AppColors.white,
        ),
      ),
    );
  }
}
