import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_banking_app/core/services/firebase_messaging_service.dart';
import 'package:mobile_banking_app/core/binding/initial_binding.dart';
import 'package:mobile_banking_app/core/constants/app_theme.dart';
import 'package:mobile_banking_app/routes/app_pages.dart';
import 'package:mobile_banking_app/core/services/auth_service.dart';
import 'package:mobile_banking_app/firebase_options.dart';

Future<void> mainFlavor() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final messagingService = FirebaseMessagingService();
  await messagingService.initialize();

  final String initialRoute = await AuthService.getInitialRoute();
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, _) {
        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => child!,
          child: GetMaterialApp(
            initialBinding: InitialBinding(),
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            enableLog: false,
            initialRoute: initialRoute,
            getPages: AppPages.routes,
          ),
        );
      },
    );
  }
}
