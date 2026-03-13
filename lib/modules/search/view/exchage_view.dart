import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/dialog/custom_simple_dialog.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class ExchageView extends StatefulWidget {
  const ExchageView({super.key});

  @override
  State<ExchageView> createState() => _ExchageViewState();
}

class _ExchageViewState extends State<ExchageView> {
  String _fromCurrency = 'USD';
  String _toCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomPopBar(text: 'Exchange'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Image.asset(AppAssets.imageIll5),
            ),
            SizedBox(height: 24.h),
            _buildCardTransfer(context),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTransfer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.dg, vertical: 16.dg),
      margin: EdgeInsets.symmetric(horizontal: 24.dm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          CustomInputField(
            label: 'From',
            keybaordType: TextInputType.number,
            suffixWidget: Container(
              width: 90.w,
              margin: EdgeInsets.symmetric(vertical: 6.dg),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1.5.w, color: AppColors.grey),
                ),
              ),
              child: GestureDetector(
                onTap: () => _selectCurrency(isFrom: true),
                child: _buildSelectCurrency(_fromCurrency),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Image.asset(AppAssets.arrowUpDown, height: 24.h),
          SizedBox(height: 8.h),
          CustomInputField(
            label: 'To',
            keybaordType: TextInputType.number,
            suffixWidget: Container(
              width: 90.w,
              margin: EdgeInsets.symmetric(vertical: 6.dg),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1.5.w, color: AppColors.grey),
                ),
              ),
              child: GestureDetector(
                onTap: () => _selectCurrency(isFrom: false),
                child: _buildSelectCurrency(_toCurrency),
              ),
            ),
          ),
          SizedBox(height: 40.h),
          CustomButtonPrimaryActive(label: 'Exchange'),
        ],
      ),
    );
  }

  Future<void> _selectCurrency({required bool isFrom}) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => CustomSimpleDialog(),
    );

    if (!mounted || selected == null) {
      return;
    }

    final code = _extractCurrencyCode(selected);

    setState(() {
      if (isFrom) {
        _fromCurrency = code;
      } else {
        _toCurrency = code;
      }
    });
  }

  String _extractCurrencyCode(String currency) {
    final trimmed = currency.trim();
    if (trimmed.isEmpty) {
      return 'USD';
    }

    return trimmed.split(' ').first;
  }

  Widget _buildSelectCurrency(String currencyCode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          currencyCode,
          style: AppTextStyles.title3.copyWith(color: AppColors.darkGrey),
        ),
        SizedBox(width: 6.w),
        Image.asset(AppAssets.arrowUnfold, height: 20.h, color: AppColors.grey),
      ],
    );
  }
}
