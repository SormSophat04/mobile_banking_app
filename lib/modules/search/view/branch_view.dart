import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/modules/search/widgets/custom_branch_search.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class BranchView extends StatelessWidget {
  const BranchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.white, body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          CustomPopBar(text: 'Branch'),
          Expanded(
            child: Stack(
              children: [
                _buildMap(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CustomBranchSearch(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      height: 295.h,
      width: double.infinity,
      color: Colors.blueGrey,
    );
  }
}
