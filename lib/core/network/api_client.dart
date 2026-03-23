import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class ApiClient extends GetConnect {
  final _storage = const FlutterSecureStorage();
  String? _token;
  String? _customerId;
  String? _customerName;

  @override
  void onInit() {
    // Determine the correct base URL based on platform
    // For Android Emulator, localhost is 10.0.2.2
    String baseUrlStr = 'http://localhost:8080/api/';
    if (!kIsWeb && Platform.isAndroid) {
      baseUrlStr = 'http://10.0.2.2:8080/api/';
    }
    
    httpClient.baseUrl = baseUrlStr;
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 30);
    
    // Inject JWT Token into the headers
    httpClient.addRequestModifier<dynamic>((request) async {
      _token ??= await _storage.read(key: 'jwt_token');
      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }
      return request;
    });

    // Handle 401 Unauthorized globally
    httpClient.addResponseModifier((request, response) async {
      if (response.statusCode == 401 && !request.url.path.contains('auth/login')) {
        debugPrint('401 Unauthorized detected. Logging out.');
        await clearAuth();
        Get.offAllNamed(AppRoutes.LOGIN);
      }
      return response;
    });

    super.onInit();
  }

  Map<String, dynamic>? _decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final String normalized = base64Url.normalize(payload);
      final String decoded = utf8.decode(base64Url.decode(normalized));
      return json.decode(decoded);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.write(key: 'jwt_token', value: token);

    // Automatically decode the token to cache the customerId and name if present
    final payload = _decodeJwt(token);
    if (payload != null) {
      final customerObj = payload['customer'] is Map ? payload['customer'] : null;
      final userObj = payload['user'] is Map ? payload['user'] : null;

      final customerId = customerObj?['customerId'] ?? userObj?['userId'] ?? 
                         payload['customerId'] ?? payload['userId'] ?? 
                         payload['sub'];
                         
      if (customerId != null) {
        await saveCustomerId(customerId.toString());
      }
      
      final firstName = customerObj?['firstName'] ?? payload['firstName'];
      final lastName = customerObj?['lastName'] ?? payload['lastName'];
      
      if (firstName != null && lastName != null) {
        await saveCustomerName('$firstName $lastName');
      } else if (payload['name'] != null) {
        await saveCustomerName(payload['name']);
      }
    }
  }

  Future<void> saveCustomerId(String id) async {
    _customerId = id;
    await _storage.write(key: 'customer_id', value: id);
  }

  Future<String?> getCustomerId() async {
    _customerId ??= await _storage.read(key: 'customer_id');
    return _customerId;
  }

  Future<void> saveCustomerName(String name) async {
    _customerName = name;
    await _storage.write(key: 'customer_name', value: name);
  }

  Future<String?> getCustomerName() async {
    _customerName ??= await _storage.read(key: 'customer_name');
    return _customerName;
  }

  Future<void> clearAuth() async {
    _token = null;
    _customerId = null;
    _customerName = null;
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'customer_id');
    await _storage.delete(key: 'customer_name');
  }

  Future<Response> login(String phone, String password) async {
    final response = await post('auth/login', {
      'phoneNumber': phone,
      'password': password,
    });
    return response;
  }

  Future<Response> register(String phone, String email, String password) async {
    final response = await post('auth/register', {
      'phoneNumber': phone,
      'email': email,
      'password': password,
    });
    return response;
  }

  Future<Response> verifyProfile(String firstName, String lastName, String nationalId, String birthDate) async {
    final response = await post('customers', {
      'firstName': firstName,
      'lastName': lastName,
      'nationalId': nationalId,
      'birthDate': birthDate,
    });
    return response;
  }

  Future<Response> getAccount(String customerId) async {
    final response = await get('accounts/customer/$customerId');
    return response;
  }

  Future<Response> getTransactions(String accountId) async {
    final response = await get('transactions/account/$accountId');
    return response;
  }

  Future<Response> getTransaction(String transactionId) async {
    final response = await get('transactions/$transactionId');
    return response;
  }

  /// Registers this device's FCM token with the backend server,
  /// linking it to the customer so the server can send push notifications.
  Future<void> saveFcmToken(String fcmToken) async {
    try {
      await _storage.write(key: 'fcm_token', value: fcmToken);
      final customerId = await getCustomerId();
      if (customerId == null) return;

      final response = await put('customers/$customerId/fcm-token', {
        'fcmToken': fcmToken,
      });

      if (response.isOk) {
        print("FCM token registered with backend for customer $customerId ✓");
      } else {
        debugPrint('Failed to register FCM token: ${response.statusCode} ${response.bodyString}');
      }
    } catch (e) {
      debugPrint('Error registering FCM token: $e');
    }
  }

  /// Retrieves the locally stored FCM token.
  Future<String?> getFcmToken() async {
    return await _storage.read(key: 'fcm_token');
  }


  /// Calls the backend to push a notification to a specific FCM device token.
  /// The backend will use Firebase Admin SDK to send the notification.
  Future<Response> sendPushNotification({
    required String toAccountNumber,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final payload = {
      'toAccountNumber': toAccountNumber, // Backend maps this to the stored FCM token
      'title': title,
      'body': body,
      'data': data ?? {},
    };
    print("===== Sending Push Notification =====");
    print("To Account: $toAccountNumber");
    print("Payload: $payload");
    final response = await post('notifications/push', payload);
    print("Push response status: ${response.statusCode}");
    print("Push response body: ${response.bodyString}");
    print("=====================================");
    return response;
  }

  /// Attempts to refresh the JWT token via backend's auth/refresh endpoint.
  Future<bool> refreshToken() async {
    try {
      final response = await post('auth/refresh', {});
      if (response.isOk && response.body != null) {
        final data = response.body;
        final token = data['token'] ?? data['access_token'] ?? data['accessToken'] ?? data['jwt'];
        if (token != null) {
          await saveToken(token.toString());
          debugPrint('Token refresh successful on startup');
          return true;
        }
      } else {
        debugPrint('Token refresh failed. Status: ${response.statusCode}');
        if (response.statusCode == 401) {
          await clearAuth();
          // We don't call Get.offAllNamed here because it might fail during initial app launch
          // if GetMaterialApp hasn't been mounted yet. The 401 interceptor or AuthService will handle routing.
        }
      }
    } catch (e) {
      debugPrint('Error during token refresh: $e');
    }
    return false;
  }
}
