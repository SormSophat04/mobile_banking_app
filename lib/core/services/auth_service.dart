import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/utils/jwt_utils.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();

  static Future<String> getInitialRoute() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token != null && !JwtDecoder.isExpired(token)) {
      try {
        final apiClient = Get.put(ApiClient());
        await apiClient.refreshToken();
        if (await _storage.read(key: 'jwt_token') != null) return AppRoutes.MAIN_LAYOUT;
      } catch (e) {
        debugPrint('Auth error: $e');
      }
    }
    await _clearStorage();
    return AppRoutes.LOGIN;
  }

  static Future<void> _clearStorage() async {
    for (var k in ['jwt_token', 'customer_id', 'customer_name']) { await _storage.delete(key: k); }
  }
}
