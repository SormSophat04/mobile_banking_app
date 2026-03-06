import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/binding/initial_binding.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_theme.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_ghost_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_ghost_dissable.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_dissable.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_round_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_round_dissable.dart';

Future<void> mainFlavor() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 9,
              children: [
                CustomButtonPrimaryActive(label: 'Primary Active'),
                CustomButtonPrimaryDissable(label: 'Primary Dissable'),
                CustomButtonGhostActive(label: 'Ghost Active'),
                CustomButtonGhostDissable(label: 'Ghost Dissable'),
                Row(
                  children: [
                    CustomButtonRoundActive(),
                    CustomButtonRoundDissable(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
