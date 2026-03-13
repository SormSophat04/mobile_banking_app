import 'package:mobile_banking_app/core/config/flavor.dart';
import 'package:mobile_banking_app/core/security/device_security_service.dart';
import 'package:mobile_banking_app/core/security/screenshot_service.dart';
import 'package:mobile_banking_app/core/security/secure_exception.dart';

class SecurityService {
  final DeviceSecurityService _deviceSecurityService = DeviceSecurityService();
  final ScreenshotService _screenshotService = ScreenshotService();

  Future<void> enforceSecurity() async {
    await _screenshotService.protect();

    if (FlavorConfig.isDev) {
      return;
    }

    final isDeviceSecure = await _deviceSecurityService.checkDeviceSecurity();

    if (!isDeviceSecure) {
      throw SecureException();
    }
  }
}
