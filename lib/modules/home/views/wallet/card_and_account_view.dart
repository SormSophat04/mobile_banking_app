import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/modules/home/controllers/card_and_account_controller.dart';
import 'package:mobile_banking_app/modules/home/views/wallet/custom_account_widget.dart';
import 'package:mobile_banking_app/modules/home/views/wallet/custom_card_widget.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_dissable.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class CardAndAccountView extends StatelessWidget {
  const CardAndAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: GetBuilder<CardAndAccountController>(
        builder: (controller) => _buildBody(controller),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(53.h),
      child: SafeArea(child: CustomPopBar(text: 'Account And Card')),
    );
  }

  Widget _buildBody(CardAndAccountController controller) {
    return Column(
      children: [
        _buildScrollBar(controller),
        SizedBox(height: 12.h),
        Expanded(child: _buildPage(controller)),
      ],
    );
  }

  Widget _buildScrollBar(CardAndAccountController controller) {
    final isAccountActive = controller.currentIndex == 0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.dg, vertical: 10.dg),
      child: Row(
        children: [
          Expanded(
            child: isAccountActive
                ? CustomButtonPrimaryActive(
                    label: 'Account',
                    onTap: () => controller.onTabSelected(0),
                  )
                : CustomButtonPrimaryDissable(
                    label: 'Account',
                    onTap: () => controller.onTabSelected(0),
                  ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: isAccountActive
                ? CustomButtonPrimaryDissable(
                    label: 'Card',
                    onTap: () => controller.onTabSelected(1),
                  )
                : CustomButtonPrimaryActive(
                    label: 'Card',
                    onTap: () => controller.onTabSelected(1),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(CardAndAccountController controller) {
    return PageView(
      controller: controller.pageController,
      onPageChanged: controller.onPageChanged,
      children: [const CustomAccountWidget(), CustomCardWidget()],
    );
  }
}
