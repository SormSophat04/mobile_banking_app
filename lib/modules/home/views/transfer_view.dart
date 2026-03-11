import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class TransferView extends StatelessWidget {
  const TransferView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(53.h),
      child: SafeArea(child: CustomPopBar(text: 'Transfer')),
    );
  }

  Widget _buildBody() {
    return Container(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.dg),
              child: CustomInputField(
                hint: 'Choose account/card',
                keybaordType: TextInputType.number,
                suffixWidget: Padding(
                  padding: EdgeInsets.all(12.dg),
                  child: Image.asset(
                    AppAssets.arrowRight,
                    height: 12.h,
                    width: 12.w,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Choose transaction',
                style: TextStyle(color: AppColors.grey),
              ),
            ),
            SizedBox(height: 16.h),
            _buildScrollTransaction(),
            SizedBox(height: 26.h),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollTransaction() {
    return Container(
      height: 120.h,
      color: Colors.blue,
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => Container(
          height: 100.h,
          width: 120.w,
          color: Colors.amber,
          margin: EdgeInsets.only(right: 24.dg),
        ),
      ),
    );
  }
}
