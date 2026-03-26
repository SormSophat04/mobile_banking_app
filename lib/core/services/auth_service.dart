import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/utils/jwt_utils.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();

  static Future<String> getInitialRoute() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    if (refreshToken != null) {
      try {
        final apiClient = Get.put(ApiClient());
        final success = await apiClient.refreshToken();
        if (success) return AppRoutes.MAIN_LAYOUT;
      } catch (e) {
        debugPrint('Auth error: $e');
      }
    }

    final token = await _storage.read(key: 'jwt_token');
    if (token != null && !JwtDecoder.isExpired(token)) {
      return AppRoutes.MAIN_LAYOUT;
    }

    await _clearStorage();
    return AppRoutes.LOGIN;
  }

  static Future<void> _clearStorage() async {
    for (var k in ['jwt_token', 'refresh_token', 'customer_id', 'customer_name']) { await _storage.delete(key: k); }
  }
}
