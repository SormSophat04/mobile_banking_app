import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/core/network/models/account_model.dart';
import 'package:mobile_banking_app/core/network/models/bank_card_model.dart';
import 'package:mobile_banking_app/modules/home/controllers/card_and_account_controller.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_dissable.dart';
import 'package:mobile_banking_app/widgets/card/custom_credit_card_widget.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardAndAccountController>(
      builder: (controller) {
        if (controller.isLoadingCards) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cards.isEmpty) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 22.dm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.cardErrorMessage.isNotEmpty
                      ? controller.cardErrorMessage
                      : 'No cards found',
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.primary,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                CustomButtonPrimaryActive(
                  label: 'Add Card',
                  onTap: () => _showAddCardForm(context, controller),
                ),
              ],
            ),
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 22.dm),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.cards.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.cards.length) {
                return Padding(
                  padding: EdgeInsets.only(top: 16.dm, bottom: 30.dm),
                  child: CustomButtonPrimaryActive(
                    label: 'Add Card',
                    onTap: () => _showAddCardForm(context, controller),
                  ),
                );
              }

              final card = controller.cards[index];

              return CustomCreditCardWidget(
                userName: _resolveCardTitle(card),
                cardNumber: _maskCardNumber(card.cardNumber),
                balance: _resolveCardSubtitle(card),
                cardType: card.cardType,
                marginTop: index == 0 ? 0 : 14,
              );
            },
          ),
        );
      },
    );
  }

  void _showAddCardForm(
    BuildContext context,
    CardAndAccountController controller,
  ) {
    final List<AccountModel> accounts = controller.accounts
        .where((account) => account.accountId != null)
        .toList();

    if (accounts.isEmpty) {
      Get.snackbar(
        'Notice',
        'No bank accounts available to link this card.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    int? selectedAccountId = accounts.first.accountId;
    String selectedCardType = 'VISA_CARD';
    bool isSubmitting = false;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (sheetContext, setState) {
          final canSubmit = selectedAccountId != null && !isSubmitting;

          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              boxShadow: AppShadows.card,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24.w,
                20.h,
                24.w,
                24.h + MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Credit Card',
                    style: AppTextStyles.title2.copyWith(
                      color: AppColors.black,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'Choose bank account',
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.grey,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<int>(
                    value: selectedAccountId,
                    decoration: _dropdownDecoration(),
                    borderRadius: BorderRadius.circular(14.r),
                    items: accounts
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
                    onChanged: (value) {
                      setState(() {
                        selectedAccountId = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Choose card type',
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.grey,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<String>(
                    value: selectedCardType,
                    decoration: _dropdownDecoration(),
                    borderRadius: BorderRadius.circular(14.r),
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'VISA_CARD',
                        child: Text('Visa'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'MASTER_CARD',
                        child: Text('Master Card'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedCardType = value;
                      });
                    },
                  ),
                  SizedBox(height: 22.h),
                  if (isSubmitting) ...[
                    const Center(child: CircularProgressIndicator()),
                  ] else ...[
                    canSubmit
                        ? CustomButtonPrimaryActive(
                            label: 'Create Card',
                            onTap: () async {
                              setState(() {
                                isSubmitting = true;
                              });

                              final created = await controller.createCard(
                                accountId: selectedAccountId!,
                                cardType: selectedCardType,
                              );

                              if (Get.isBottomSheetOpen ?? false) {
                                setState(() {
                                  isSubmitting = false;
                                });
                              }

                              if (created) {
                                if (Get.isBottomSheetOpen ?? false) {
                                  Get.back();
                                }
                                Get.snackbar(
                                  'Success',
                                  'New credit card added.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } else {
                                Get.snackbar(
                                  'Failed',
                                  controller.cardErrorMessage.isNotEmpty
                                      ? controller.cardErrorMessage
                                      : 'Unable to create card.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                          )
                        : const CustomButtonPrimaryDissable(
                            label: 'Create Card',
                          ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  String _resolveCardTitle(BankCardModel card) {
    final type = card.accountType?.trim();
    if (type != null && type.isNotEmpty) {
      return type;
    }
    final accountNumber = card.accountNumber?.trim();
    if (accountNumber != null && accountNumber.isNotEmpty) {
      return 'Account $accountNumber';
    }
    return 'Mobile Banking';
  }

  String _resolveCardSubtitle(BankCardModel card) {
    if (card.balance != null) {
      return _formatBalance(card.balance, card.currency);
    }

    final expiry = _formatExpiryDate(card.expiryDate);
    if (expiry.isNotEmpty) {
      return 'Exp $expiry';
    }

    final status = card.status?.trim();
    if (status != null && status.isNotEmpty) {
      return status;
    }
    return 'ACTIVE';
  }

  String _maskCardNumber(String? rawCardNumber) {
    if (rawCardNumber == null || rawCardNumber.trim().isEmpty) {
      return '**** **** **** ****';
    }

    final digits = rawCardNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return rawCardNumber;
    }

    if (digits.length <= 4) {
      return _groupBy4(digits);
    }

    final hidden = List.filled(digits.length - 4, '*').join();
    final masked = '$hidden${digits.substring(digits.length - 4)}';
    return _groupBy4(masked);
  }

  String _formatBalance(double? balance, String? currency) {
    final amount = (balance ?? 0).toStringAsFixed(2);
    final symbol = _resolveCurrency(currency);

    if (symbol == null || symbol.isEmpty) {
      return amount;
    }
    if (symbol == '\$' || symbol == '៛') {
      return '$symbol$amount';
    }
    return '$amount $symbol';
  }

  String _formatExpiryDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return '';
    }
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) {
      return rawDate;
    }
    final month = parsed.month.toString().padLeft(2, '0');
    final year = (parsed.year % 100).toString().padLeft(2, '0');
    return '$month/$year';
  }

  String _groupBy4(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      buffer.write(input[i]);
      if ((i + 1) % 4 == 0 && i != input.length - 1) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  String? _resolveCurrency(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final upper = value.toUpperCase();
    if (upper == '0' || upper == 'USD' || value == '\$') {
      return '\$';
    }
    if (upper == '1' || upper == 'KHR' || value == '៛') {
      return '៛';
    }
    return value;
  }
}
