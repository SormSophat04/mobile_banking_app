import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/core/network/models/loan_model.dart';
import 'package:mobile_banking_app/modules/home/controllers/loan_controller.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class LoanView extends StatelessWidget {
  const LoanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(53.h),
        child: const SafeArea(child: CustomPopBar(text: 'Loan')),
      ),
      body: GetBuilder<LoanController>(
        initState: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.isRegistered<LoanController>()) {
              Get.find<LoanController>().refreshLoan();
            }
          });
        },
        builder: (controller) => _buildBody(controller),
      ),
    );
  }

  Widget _buildBody(LoanController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final isNoLoanState =
        controller.errorMessage == 'No loan found.' ||
        controller.errorMessage == 'No loan data found in response.';

    if (isNoLoanState) {
      return _buildNoLoanState(controller);
    }

    if (controller.errorMessage.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.errorMessage,
                textAlign: TextAlign.center,
                style: AppTextStyles.body1.copyWith(color: AppColors.danger),
              ),
              SizedBox(height: 16.h),
              CustomButtonPrimaryActive(
                label: 'Try Again',
                onTap: controller.refreshLoan,
              ),
            ],
          ),
        ),
      );
    }

    final loan = controller.loan;
    if (loan == null) {
      return _buildNoLoanState(controller);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: controller.refreshLoan,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(24.dg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLoanBalanceCard(loan),
            SizedBox(height: 16.h),
            _buildCustomerCard(loan),
            SizedBox(height: 24.h),
            Text(
              'Next Payment',
              style: AppTextStyles.title2.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 16.h),
            _buildNextPaymentCard(loan),
            SizedBox(height: 24.h),
            Text(
              'Loan Summary',
              style: AppTextStyles.title2.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 16.h),
            _buildSummaryCard(loan),
            SizedBox(height: 24.h),
            Text(
              'Export Excel',
              style: AppTextStyles.title2.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 16.h),
            _buildExportSection(controller, loan),
            SizedBox(height: 32.h),
            CustomButtonPrimaryActive(
              label: 'Refresh Loan Data',
              onTap: controller.refreshLoan,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoLoanState(LoanController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You do not have any active loan yet.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 16.h),
            CustomButtonPrimaryActive(
              label: 'Create Loan',
              onTap: () => Get.toNamed(AppRoutes.LOAN_CALCULATOR),
            ),
            SizedBox(height: 12.h),
            CustomButtonPrimaryActive(
              label: 'Refresh',
              onTap: controller.refreshLoan,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportSection(LoanController controller, LoanModel loan) {
    final createdAt = DateTime.tryParse(loan.createAt ?? '');
    final now = DateTime.now();
    final initialYear = createdAt?.year ?? now.year;
    final initialMonth = createdAt?.month ?? now.month;

    final isExporting = controller.isExportingByLoanId || controller.isExportingByPeriod;

    return Column(
      children: [
        CustomButtonPrimaryActive(
          label: controller.isExportingByLoanId
              ? 'Exporting by Loan ID...'
              : 'Export Current Loan',
          onTap: isExporting ? null : controller.exportLoanExcelByLoanId,
        ),
        SizedBox(height: 12.h),
        CustomButtonPrimaryActive(
          label: controller.isExportingByPeriod
              ? 'Exporting by Month...'
              : 'Export by Year & Month',
          onTap: isExporting
              ? null
              : () => _showPeriodExportDialog(
                    controller,
                    initialYear: initialYear,
                    initialMonth: initialMonth,
                  ),
        ),
      ],
    );
  }

  void _showPeriodExportDialog(
    LoanController controller, {
    required int initialYear,
    required int initialMonth,
  }) {
    final yearController = TextEditingController(text: initialYear.toString());
    final monthController = TextEditingController(
      text: initialMonth.toString().padLeft(2, '0'),
    );

    showDialog<void>(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Export by Period',
            style: AppTextStyles.title3.copyWith(color: AppColors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  hintText: 'e.g. 2026',
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: monthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Month',
                  hintText: '1 - 12',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final year = int.tryParse(yearController.text.trim());
                final month = int.tryParse(monthController.text.trim());

                if (year == null || month == null || month < 1 || month > 12) {
                  Get.snackbar(
                    'Invalid Date',
                    'Please enter a valid year and month.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                Navigator.of(context).pop();
                controller.exportLoanExcelByPeriod(year: year, month: month);
              },
              child: const Text('Export'),
            ),
          ],
        );
      },
    ).whenComplete(() {
      yearController.dispose();
      monthController.dispose();
    });
  }

  Widget _buildLoanBalanceCard(LoanModel loan) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.dg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.dg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Outstanding Balance',
            style: AppTextStyles.body2.copyWith(color: AppColors.primarySoft),
          ),
          SizedBox(height: 8.h),
          Text(
            _formatAmount(loan.principal, loan.currency),
            style: AppTextStyles.title1.copyWith(fontSize: 32.sp),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Interest Rate', style: AppTextStyles.caption2),
                  SizedBox(height: 4.h),
                  Text(
                    '${(loan.interestRate ?? 0).toStringAsFixed(2)}% p.a.',
                    style: AppTextStyles.body1,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Loan Term', style: AppTextStyles.caption2),
                  SizedBox(height: 4.h),
                  Text(
                    '${loan.durationMonths ?? 0} months',
                    style: AppTextStyles.body1,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(LoanModel loan) {
    final customer = loan.customer;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.dg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer',
            style: AppTextStyles.body1.copyWith(color: AppColors.black),
          ),
          SizedBox(height: 12.h),
          _buildDetailRow('Name', customer?.fullName ?? 'N/A'),
          _buildDetailRow('Customer ID', '${customer?.customerId ?? '-'}'),
          _buildDetailRow('Phone', customer?.phone ?? 'N/A'),
          _buildDetailRow('Email', customer?.email ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildNextPaymentCard(LoanModel loan) {
    return Container(
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.dg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 48.w,
                width: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.warning.withAlpha(25),
                  borderRadius: BorderRadius.circular(12.dg),
                ),
                child: Center(
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.warning,
                    size: 24.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Due Next Month',
                    style: AppTextStyles.body1.copyWith(color: AppColors.black),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Minimum: ${_formatAmount(loan.monthlyPayment, loan.currency)}',
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            _formatAmount(loan.monthlyPayment, loan.currency),
            style: AppTextStyles.title2.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(LoanModel loan) {
    return Container(
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.dg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          _buildDetailRow(
            'Loan Amount',
            _formatAmount(loan.loanAmount, loan.currency),
          ),
          _buildDetailRow(
            'Principal',
            _formatAmount(loan.principal, loan.currency),
          ),
          _buildDetailRow(
            'Total Interest',
            _formatAmount(loan.totalInterest, loan.currency),
          ),
          _buildDetailRow(
            'Total Repayment',
            _formatAmount(loan.totalRepayment, loan.currency),
            highlight: true,
          ),
          _buildDetailRow('Loan ID', '${loan.loanId ?? '-'}'),
          _buildDetailRow('Created At', _formatDate(loan.createAt)),
          _buildDetailRow('Updated At', _formatDate(loan.updateAt)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body2.copyWith(color: AppColors.darkGrey),
          ),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(
              color: highlight ? AppColors.primary : AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double? amount, String? currency) {
    final value = (amount ?? 0).toStringAsFixed(2);
    final symbol = _resolveCurrencySymbol(currency);

    if (symbol.isEmpty) {
      return value;
    }

    if (symbol == '\$' || symbol == '៛') {
      return '$symbol$value';
    }
    return '$value $symbol';
  }

  String _resolveCurrencySymbol(String? currency) {
    if (currency == null || currency.trim().isEmpty) {
      return '';
    }

    final value = currency.trim().toUpperCase();
    if (value == 'USD' || value == '0') {
      return '\$';
    }
    if (value == 'KHR' || value == '1') {
      return '៛';
    }
    return currency.trim();
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return 'N/A';
    }

    final date = DateTime.tryParse(rawDate);
    if (date == null) {
      return rawDate;
    }

    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute';
  }
}
