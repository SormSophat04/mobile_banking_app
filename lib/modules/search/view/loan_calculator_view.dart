import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class LoanCalculatorView extends StatefulWidget {
  const LoanCalculatorView({super.key});

  @override
  State<LoanCalculatorView> createState() => _LoanCalculatorViewState();
}

class _LoanCalculatorViewState extends State<LoanCalculatorView> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _termController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();

  double _monthlyPayment = 0.0;
  double _totalPayment = 0.0;
  double _totalInterest = 0.0;

  void _calculateLoan() {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    
    final double amount = double.tryParse(_amountController.text) ?? 0.0;
    final int months = int.tryParse(_termController.text) ?? 0;
    final double annualInterestRate = double.tryParse(_interestController.text) ?? 0.0;

    if (amount <= 0 || months <= 0) {
      setState(() {
        _monthlyPayment = 0.0;
        _totalPayment = 0.0;
        _totalInterest = 0.0;
      });
      return;
    }

    if (annualInterestRate == 0) {
      setState(() {
        _monthlyPayment = amount / months;
        _totalPayment = amount;
        _totalInterest = 0.0;
      });
      return;
    }

    final double monthlyInterestRate = (annualInterestRate / 100) / 12;
    
    // M = P [ I(1 + I)^N ] / [ (1 + I)^N - 1 ]
    final double powTerm = pow(1 + monthlyInterestRate, months).toDouble();
    final double emi = amount * (monthlyInterestRate * powTerm) / (powTerm - 1);
    final double totalPayment = emi * months;
    final double totalInterest = totalPayment - amount;

    setState(() {
      _monthlyPayment = emi;
      _totalPayment = totalPayment;
      _totalInterest = totalInterest;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _termController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const SafeArea(child: CustomPopBar(text: 'Loan Calculator')),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.white,
              boxShadow: AppShadows.cardSmall,
            ),
            child: Column(
              children: [
                CustomInputField(
                  hint: 'Loan amount',
                  keybaordType: TextInputType.number,
                  controller: _amountController,
                ),
                const SizedBox(height: 12),
                const CustomInputField(
                  hint: 'Currency',
                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                  text: 'USD',
                  isReadOnly: true,
                ),
                const SizedBox(height: 12),
                CustomInputField(
                  hint: 'Loan term (months)',
                  keybaordType: TextInputType.number,
                  controller: _termController,
                ),
                const SizedBox(height: 12),
                CustomInputField(
                  hint: 'Interest rate (%)',
                  keybaordType: TextInputType.number,
                  controller: _interestController,
                ),
                const SizedBox(height: 24),
                CustomButtonPrimaryActive(
                  label: 'Calculate',
                  onTap: _calculateLoan,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.white,
              boxShadow: AppShadows.cardSmall,
            ),
            child: Column(
              children: [
                _buildResultRow('Monthly payment', '\$${_monthlyPayment.toStringAsFixed(2)}'),
                const SizedBox(height: 12),
                _buildResultRow('Total payment', '\$${_totalPayment.toStringAsFixed(2)}'),
                const SizedBox(height: 12),
                _buildResultRow('Total interest', '\$${_totalInterest.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
      ],
    );
  }
}
