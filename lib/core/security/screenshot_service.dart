import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';

class ScreenshotService {
  Future<void> protect() async {
    await FlutterWindowManagerPlus.addFlags(
      FlutterWindowManagerPlus.FLAG_SECURE,
    );
  }
}
