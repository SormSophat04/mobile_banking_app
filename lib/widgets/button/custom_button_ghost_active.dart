import 'package:flutter/widgets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';

class CustomButtonGhostActive extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const CustomButtonGhostActive({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.danger,
            ),
          ),
        ),
      ),
    );
  }
}
