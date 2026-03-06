import 'package:flutter/widgets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';

class CustomButtonRoundDissable extends StatelessWidget {
  final VoidCallback? onTap;
  const CustomButtonRoundDissable({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            'assets/icons/05.png',
            width: 16,
            height: 16,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
