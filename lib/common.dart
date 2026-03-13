import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/binding/initial_binding.dart';
import 'package:mobile_banking_app/core/constants/app_theme.dart';
import 'package:mobile_banking_app/routes/app_pages.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

Future<void> mainFlavor() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          initialBinding: InitialBinding(),
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.LOGIN,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
