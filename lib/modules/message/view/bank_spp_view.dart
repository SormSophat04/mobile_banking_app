import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_round_active.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class BankSppView extends StatelessWidget {
  const BankSppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          CustomPopBar(text: 'Bank of Cambodia'),
          SizedBox(height: 12),
          Expanded(
            child: Container(
              // color: Colors.cyanAccent,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: _buildSearch(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomInputField(
            hint: 'Type something....',
            keybaordType: TextInputType.text,
          ),
        ),
        SizedBox(width: 12.w),
        CustomButtonRoundActive(),
      ],
    );
  }
}
