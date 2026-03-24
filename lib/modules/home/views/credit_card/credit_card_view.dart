import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/credit_card_controller.dart';
import 'package:mobile_banking_app/widgets/card/custom_credit_card_widget.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class CreditCardView extends StatelessWidget {
  const CreditCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      appBar: _buildAppBar(),
      body: GetBuilder<CreditCardController>(
        builder: (controller) => _buildBody(controller),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(53.h),
      child: SafeArea(child: CustomPopBar(text: 'Credit card', bg: true)),
    );
  }

  Widget _buildBody(CreditCardController controller) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: EdgeInsets.only(top: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.dg),
          topRight: Radius.circular(24.dg),
        ),
      ),
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: controller.refreshCurrentData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.dg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                _buildAccountSelector(controller),
                SizedBox(height: 16.h),
                _buildCardsSection(controller),
                SizedBox(height: 28.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSelector(CreditCardController controller) {
    if (controller.isLoadingAccounts) {
      return const Center(child: CircularProgressIndicator());
    }

    final availableAccounts = controller.accounts
        .where((account) => account.accountId != null)
        .toList();

    if (availableAccounts.isEmpty) {
      return _buildMessage(
        controller.errorMessage.isNotEmpty
            ? controller.errorMessage
            : 'No account available',
      );
    }

    final selectedValue =
        availableAccounts.any((e) => e.accountId == controller.selectedAccountId)
        ? controller.selectedAccountId
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select account',
          style: AppTextStyles.caption2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedValue,
              isExpanded: true,
              hint: Text(
                'Choose account',
                style: AppTextStyles.body3.copyWith(color: AppColors.darkGrey),
              ),
              items: availableAccounts
                  .map(
                    (account) => DropdownMenuItem<int>(
                      value: account.accountId,
                      child: Text(
                        '${account.accountType ?? 'Account'} - ${account.accountNumber ?? account.accountId}',
                        style: AppTextStyles.body3.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: controller.isLoadingCards
                  ? null
                  : controller.onAccountSelected,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardsSection(CreditCardController controller) {
    if (controller.isLoadingAccounts || controller.isLoadingCards) {
      return Padding(
        padding: EdgeInsets.only(top: 28.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.cards.isEmpty) {
      return _buildMessage(
        controller.errorMessage.isNotEmpty
            ? controller.errorMessage
            : 'No cards found for selected account.',
      );
    }

    return Column(
      children: List.generate(controller.cards.length, (index) {
        final card = controller.cards[index];
        final expiry = controller.formatExpiryDate(card.expiryDate);
        final cardFooter = expiry.isNotEmpty
            ? 'Exp $expiry'
            : (card.accountNumber != null && card.accountNumber!.isNotEmpty)
            ? 'Acc ${card.accountNumber}'
            : controller.formatBalance(card.balance, card.currency);

        return CustomCreditCardWidget(
          userName: controller.resolveCardHolderName(card),
          cardNumber: controller.maskedCardNumber(card.cardNumber),
          balance: cardFooter,
          cardType: card.cardType,
          isSelected: index == controller.selectedCardIndex,
          onTap: () => controller.selectCard(index),
        );
      }),
    );
  }

  Widget _buildMessage(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 22.h),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption2.copyWith(
            color: AppColors.primary,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
