import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();

  static Future<String> getInitialRoute() async {
    final token = await _storage.read(key: 'jwt_token');
    
    if (token != null) {
      try {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          final String normalized = base64Url.normalize(payload);
          final String decoded = utf8.decode(base64Url.decode(normalized));
          final Map<String, dynamic> data = json.decode(decoded);
          
          if (data.containsKey('exp')) {
            final int exp = data['exp'];
            final DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
            
            if (DateTime.now().isBefore(expirationDate)) {
              // Token is valid. Make sure to refresh it immediately on startup.
              final apiClient = Get.put(ApiClient());
              await apiClient.refreshToken();
              
              // If the refresh resulted in a 401, the token was cleared.
              // Otherwise, we can safely proceed to the main layout.
              final currentToken = await _storage.read(key: 'jwt_token');
              if (currentToken != null) {
                return AppRoutes.MAIN_LAYOUT;
              } else {
                return AppRoutes.LOGIN;
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Error decoding JWT on startup: $e');
      }
    }
    
    // If token is missing, invalid, or expired, clear storage and go to login.
    await _clearStorage();
    return AppRoutes.LOGIN;
  }
  
  static Future<void> _clearStorage() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'customer_id');
    await _storage.delete(key: 'customer_name');
  }
}
