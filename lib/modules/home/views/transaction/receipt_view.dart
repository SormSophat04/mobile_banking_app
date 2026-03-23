import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/network/models/transaction_model.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class ReceiptView extends StatelessWidget {
  final TransactionModel transaction;
  final int? myAccountId;
  final String? accountCurrency;

  const ReceiptView({
    super.key,
    required this.transaction,
    this.myAccountId,
    this.accountCurrency,
  });

  static const double _usdToKhr = 4100.0;

  double _convertAmount(double amount, String fromCurrency, String toCurrency) {
    final from = fromCurrency.toUpperCase();
    final to = toCurrency.toUpperCase();
    if (from == to) return amount;
    if ((from == '\$' || from == 'USD') && (to == '៛' || to == 'KHR')) {
      return amount * _usdToKhr;
    }
    if ((from == '៛' || from == 'KHR') && (to == '\$' || to == 'USD')) {
      return amount / _usdToKhr;
    }
    return amount;
  }

  @override
  Widget build(BuildContext context) {
    final isDebit =
        myAccountId != null && transaction.senderAccountId == myAccountId;

    final senderCurr =
        transaction.senderCurrency ?? transaction.currency ?? '\$';
    final receiverCurr =
        transaction.receiverCurrency ?? transaction.currency ?? '\$';
    final acctCurr = accountCurrency ?? (isDebit ? senderCurr : receiverCurr);

    final rawAmount = transaction.amount?.abs() ?? 0.0;
    double displayAmount = rawAmount;
    String displayCurrency = senderCurr;
    String? originalAmountNote;

    // If the viewer's account currency differs from sender's, convert to viewer's currency
    if (acctCurr != senderCurr) {
      displayAmount = _convertAmount(rawAmount, senderCurr, acctCurr);
      displayCurrency = acctCurr;
      originalAmountNote =
          'Original: $senderCurr${rawAmount.toStringAsFixed(2)}';
    }

    final otherName = isDebit
        ? transaction.receiverName
        : transaction.senderName;
    final otherPhone = isDebit
        ? transaction.receiverPhone
        : transaction.senderPhone;
    final otherAccount = isDebit
        ? transaction.receiverAccountNumber
        : transaction.senderAccountNumber;

    String dateStr = '';
    if (transaction.createAt != null) {
      try {
        final dt = DateTime.parse(transaction.createAt!).toLocal();
        dateStr =
            '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        dateStr = transaction.createAt!;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(53.h),
        child: SafeArea(
          child: CustomPopBar(text: 'Transaction Receipt', bg: true),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transaction Details',
                style: AppTextStyles.title3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 32.h),
              _buildRow('Name', otherName ?? 'N/A'),
              SizedBox(height: 16.h),
              _buildRow('Phone number', otherPhone ?? 'N/A'),
              SizedBox(height: 16.h),
              _buildRow(
                'Account Number',
                otherAccount ?? 'N/A',
                isCopyable: true,
              ),
              SizedBox(height: 16.h),
              _buildRow(
                'Code',
                transaction.referenceNumber != null
                    ? '#${transaction.referenceNumber}'
                    : 'N/A',
              ),
              SizedBox(height: 16.h),
              _buildRow('Date', dateStr),
              SizedBox(height: 16.h),
              _buildRow('Type', transaction.transactionType ?? 'TRANSFER'),
              SizedBox(height: 16.h),
              if (transaction.description != null &&
                  transaction.description!.isNotEmpty) ...[
                _buildRow('Description', transaction.description!),
                SizedBox(height: 16.h),
              ],
              _buildRow(
                'Status',
                transaction.status ?? 'N/A',
                valueColor: transaction.status?.toLowerCase() == 'success'
                    ? Colors.green
                    : Colors.orange,
              ),
              SizedBox(height: 16.h),
              _buildRow(
                'Amount',
                '$displayCurrency ${displayAmount.toStringAsFixed(2)}',
                valueColor: AppColors.primary,
                subLabel: originalAmountNote,
              ),
              SizedBox(height: 24.h),
              Divider(color: Colors.grey.shade300, thickness: 1),
              SizedBox(height: 24.h),
              _buildRow(
                'TOTAL',
                '$displayCurrency ${displayAmount.toStringAsFixed(2)}',
                isTotal: true,
                valueColor: AppColors.danger,
                subLabel: originalAmountNote,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
    bool isCopyable = false,
    String? subLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.grey,
                  fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
                  fontSize: isTotal ? 16.sp : 14.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.body1.copyWith(
                            color: valueColor ?? AppColors.black,
                            fontWeight: isTotal
                                ? FontWeight.w700
                                : FontWeight.w600,
                            fontSize: isTotal ? 24.sp : 14.sp,
                          ),
                        ),
                        if (subLabel != null)
                          Text(
                            subLabel,
                            textAlign: TextAlign.right,
                            style: AppTextStyles.caption1.copyWith(
                              color: AppColors.grey,
                              fontSize: 10.sp,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isCopyable && value != 'N/A') ...[
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: value));
                        Get.snackbar(
                          'Copied',
                          'Account number copied to clipboard',
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.all(16.dm),
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: Icon(
                        Icons.copy_rounded,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
