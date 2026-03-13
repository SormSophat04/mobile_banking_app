import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/security/security_service.dart';
import 'package:mobile_banking_app/core/security/secure_exception.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class SecurityMiddleware extends GetMiddleware {
  final SecurityService _securityService = SecurityService();
  static bool _blocked = false;
  static bool _checking = false;

  @override
  RouteSettings? redirect(String? route) {
    if (route == AppRoutes.SECURITY_BLOCKED || _blocked || _checking) {
      return null;
    }

    _checking = true;
    _securityService
        .enforceSecurity()
        .then((_) {
          _checking = false;
        })
        .catchError((error) {
          _checking = false;
          if (error is SecureException) {
            _blocked = true;
            if (Get.currentRoute != AppRoutes.SECURITY_BLOCKED) {
              Get.offAllNamed(AppRoutes.SECURITY_BLOCKED);
            }
          }
        });
    return null;
  }

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig? route) async {
    if (_blocked || route?.locationString == AppRoutes.SECURITY_BLOCKED) {
      return route;
    }
    try {
      await _securityService.enforceSecurity();
      return route;
    } on SecureException {
      _blocked = true;
      return GetNavConfig.fromRoute(AppRoutes.SECURITY_BLOCKED);
    }
  }
}
