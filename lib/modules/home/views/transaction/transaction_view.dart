import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/core/network/models/transaction_model.dart';
import 'package:mobile_banking_app/modules/home/controllers/transaction_controller.dart';
import 'package:mobile_banking_app/modules/home/views/transaction/receipt_view.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionController>(
      init: TransactionController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.primaryLight,
          appBar: _buildAppBar(controller),
          body: _buildBody(controller),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(TransactionController controller) {
    return PreferredSize(
      preferredSize: Size.fromHeight(53.h),
      child: SafeArea(
        child: CustomPopBar(text: 'Transaction Report', bg: true),
      ),
    );
  }

  Widget _buildBody(TransactionController controller) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          margin: EdgeInsets.only(top: 100.h),
          padding: EdgeInsets.only(top: 6.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26.dg),
              topRight: Radius.circular(26.dg),
            ),
          ),
          child: _buildContent(controller),
        ),
        // Account info card at the top
        Positioned(
          top: 12.h,
          left: 24.w,
          right: 24.w,
          child: _buildAccountCard(controller),
        ),
      ],
    );
  }

  Widget _buildAccountCard(TransactionController controller) {
    final account = controller.account;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account?.accountType ?? 'Account',
                style: AppTextStyles.title3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Text(
                    account?.accountNumber ?? '—',
                    style: AppTextStyles.caption1.copyWith(color: Colors.white70),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      final accStr = account?.accountNumber ?? '';
                      if (accStr.isNotEmpty && accStr != '—') {
                        Clipboard.setData(ClipboardData(text: accStr));
                        Get.snackbar(
                          'Copied',
                          'Account number copied to clipboard',
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.all(16.dm),
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                    child: Icon(Icons.copy_rounded, size: 14.sp, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Balance',
                style: AppTextStyles.caption1.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 4.h),
              Text(
                '${account?.currency ?? '\$'} ${account?.balance?.toStringAsFixed(2) ?? '0.00'}',
                style: AppTextStyles.title3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(TransactionController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.dm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48.sp, color: AppColors.danger),
              SizedBox(height: 12.h),
              Text(
                controller.errorMessage,
                style: AppTextStyles.body2.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: controller.refreshTransactions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Retry',
                  style: AppTextStyles.body2.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.dm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64.sp,
                color: AppColors.grey,
              ),
              SizedBox(height: 12.h),
              Text(
                'No transactions yet',
                style: AppTextStyles.body1.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchTransactions,
      color: AppColors.primary,
      child: ListView.builder(
        padding: EdgeInsets.only(
          top: 20.h,
          bottom: 24.h,
          left: 16.w,
          right: 16.w,
        ),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: controller.transactions.length,
        itemBuilder: (context, index) {
          return _buildTransactionItem(
            controller.transactions[index],
            controller.account?.accountId,
            controller.account?.currency,
          );
        },
      ),
    );
  }

  // USD to KHR static rate
  static const double _usdToKhr = 4100.0;

  double _convertAmount(double amount, String fromCurrency, String toCurrency) {
    final from = fromCurrency.toUpperCase();
    final to = toCurrency.toUpperCase();
    if (from == to) return amount;
    // USD → KHR
    if ((from == '\$' || from == 'USD') && (to == '៛' || to == 'KHR')) {
      return amount * _usdToKhr;
    }
    // KHR → USD
    if ((from == '៛' || from == 'KHR') && (to == '\$' || to == 'USD')) {
      return amount / _usdToKhr;
    }
    return amount; // unknown pair, no conversion
  }

  Widget _buildTransactionItem(TransactionModel tx, int? myAccountId, [String? accountCurrency]) {
    // Compare by account ID — most reliable since IDs are always exact integers
    final bool isDebit =
        myAccountId != null && tx.senderAccountId == myAccountId;

    final senderCurr = tx.senderCurrency ?? tx.currency ?? '\$';
    final receiverCurr = tx.receiverCurrency ?? tx.currency ?? '\$';
    final acctCurr = accountCurrency ?? (isDebit ? senderCurr : receiverCurr);

    // When receiver gets a cross-currency payment, convert to their account currency
    final rawAmount = tx.amount?.abs() ?? 0.0;
    double displayAmount = rawAmount;
    String currencyLabel = isDebit ? senderCurr : receiverCurr;
    String? originalAmountNote;

    if (!isDebit && senderCurr != acctCurr) {
      // Received in a different currency — convert to account currency
      displayAmount = _convertAmount(rawAmount, senderCurr, acctCurr);
      currencyLabel = acctCurr;
      originalAmountNote = '($senderCurr${rawAmount.toStringAsFixed(2)})';
    }

    final amountText =
        '${isDebit ? '-' : '+'}$currencyLabel${displayAmount.toStringAsFixed(2)}';
    final amountColor = isDebit ? AppColors.danger : AppColors.primary;

    // Format date
    String dateStr = '';
    if (tx.createAt != null) {
      try {
        final dt = DateTime.parse(tx.createAt!).toLocal();
        dateStr =
            '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        dateStr = tx.createAt!;
      }
    }

    final otherAccount =
        isDebit ? tx.receiverAccountNumber : tx.senderAccountNumber;
    final otherName = isDebit ? tx.receiverName : tx.senderName;
    final direction = isDebit ? 'To' : 'From';

    return GestureDetector(
      onTap: () => Get.to(() => ReceiptView(transaction: tx, myAccountId: myAccountId, accountCurrency: accountCurrency)),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          // Icon
          Container(
            height: 44.h,
            width: 44.w,
            decoration: BoxDecoration(
              color: isDebit
                  ? AppColors.danger.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDebit
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: amountColor,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  otherName ?? tx.description ?? tx.transactionType ?? 'Transaction',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                if (otherAccount != null && otherAccount.isNotEmpty)
                  Text(
                    '$direction: $otherAccount',
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (dateStr.isNotEmpty)
                  Text(
                    dateStr,
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.grey,
                      fontSize: 10.sp,
                    ),
                  ),
              ],
            ),
          ),
          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountText,
                style: AppTextStyles.title3.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (originalAmountNote != null)
                Text(
                  originalAmountNote,
                  style: AppTextStyles.caption1.copyWith(
                    color: AppColors.grey,
                    fontSize: 9.sp,
                  ),
                ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color:
                      tx.status?.toLowerCase() == 'success' ||
                          tx.status?.toLowerCase() == 'completed'
                      ? Colors.green.withOpacity(0.12)
                      : Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  tx.status ?? 'N/A',
                  style: AppTextStyles.caption1.copyWith(
                    color:
                        tx.status?.toLowerCase() == 'success' ||
                            tx.status?.toLowerCase() == 'completed'
                        ? Colors.green
                        : Colors.orange,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
