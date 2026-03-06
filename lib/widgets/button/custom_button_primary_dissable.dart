import 'package:flutter/widgets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';

class CustomButtonPrimaryDissable extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const CustomButtonPrimaryDissable({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(child: Text(label, style: AppTextStyles.body1)),
      ),
    );
  }
}
