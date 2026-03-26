import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_banking_app/core/utils/jwt_utils.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class ApiClient extends GetConnect {
  static const _storage = FlutterSecureStorage();
  String? _token, _refreshToken, _customerId, _customerName, _customerPhone;

  @override
  void onInit() {
    httpClient.baseUrl = !kIsWeb && Platform.isAndroid ? 'http://10.0.2.2:8080/api/' : 'http://localhost:8080/api/';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 30);

    httpClient.addRequestModifier<dynamic>((request) async {
      _token ??= await _storage.read(key: 'jwt_token');
      if (_token != null) request.headers['Authorization'] = 'Bearer $_token';
      return request;
    });

    httpClient.addResponseModifier((request, response) async {
      if (response.statusCode == 401 && !request.url.path.contains('auth/login')) {
        final success = await refreshToken();
        if (success) {
          final newToken = await _storage.read(key: 'jwt_token');
          if (newToken != null) {
            request.headers['Authorization'] = 'Bearer $newToken';
            return await httpClient.request(
              request.url.path,
              request.method,
              body: request.bodyBytes,
              headers: request.headers,
            );
          }
        }
        await clearAuth();
        Get.offAllNamed(AppRoutes.LOGIN);
      }
      return response;
    });
    super.onInit();
  }

  Future<void> saveToken(String token, {String? refreshToken}) async {
    _token = token;
    await _storage.write(key: 'jwt_token', value: token);
    
    if (refreshToken != null) {
      _refreshToken = refreshToken;
      await _storage.write(key: 'refresh_token', value: refreshToken);
    }

    final payload = JwtDecoder.decode(token);
    if (payload == null) return;

    final customer = payload['customer'] ?? payload['user'] ?? payload;
    final id = customer['customerId'] ?? customer['userId'] ?? payload['sub'];
    if (id != null) await saveCustomerId(id.toString());

    final name = customer['firstName'] != null ? "${customer['firstName']} ${customer['lastName']}" : payload['name'];
    if (name != null) await saveCustomerName(name);

    final phone = customer['phone'] ?? customer['phoneNumber'] ?? payload['phone'] ?? payload['phoneNumber'];
    if (phone != null) await saveCustomerPhone(phone.toString());
  }

  Future<String?> getRefreshToken() async => _refreshToken ??= await _storage.read(key: 'refresh_token');

  Future<void> saveCustomerId(String id) async { _customerId = id; await _storage.write(key: 'customer_id', value: id); }
  Future<String?> getCustomerId() async => _customerId ??= await _storage.read(key: 'customer_id');

  Future<void> saveCustomerName(String name) async { _customerName = name; await _storage.write(key: 'customer_name', value: name); }
  Future<String?> getCustomerName() async => _customerName ??= await _storage.read(key: 'customer_name');

  Future<void> saveCustomerPhone(String phone) async { _customerPhone = phone; await _storage.write(key: 'customer_phone', value: phone); }
  Future<String?> getCustomerPhone() async {
    _customerPhone ??= await _storage.read(key: 'customer_phone');
    if (_customerPhone == null || _customerPhone!.isEmpty) {
      final token = await _storage.read(key: 'jwt_token');
      if (token != null) await saveToken(token); // Triggers re-decoding
    }
    return _customerPhone;
  }

  Future<void> clearAuth() async {
    _token = _refreshToken = _customerId = _customerName = _customerPhone = null;
    for (var k in ['jwt_token', 'refresh_token', 'customer_id', 'customer_name', 'customer_phone']) { await _storage.delete(key: k); }
  }

  // Auth Methods
  Future<Response> login(String phone, String password) => post('auth/login', {'phoneNumber': phone, 'password': password});
  Future<Response> register(String phone, String email, String password) => post('auth/register', {'phoneNumber': phone, 'email': email, 'password': password});

  // Business Methods
  Future<Response> verifyProfile(String f, String l, String n, String b) => post('customers', {'firstName': f, 'lastName': l, 'nationalId': n, 'birthDate': b});
  Future<Response> getAccount(String id) => get('accounts/customer/$id');
  Future<Response> getCardsByAccount(String id) => get('cards/account/$id');
  Future<Response> createCard({required int accountId, required String cardType}) => post('cards', {'accountId': accountId, 'cardType': cardType, 'account': {'accountId': accountId}});
  
  Future<Response> getTransactions(String id) async {
    final res = await get('transactions/accounts/$id');
    return res.statusCode == 404 ? await get('transactions/account/$id') : res;
  }
  
  Future<Response> getTransaction(String id) => get('transactions/$id');

  Future<Response> getKhqr(String accountId, {double? amount, String? bakongAccountId}) {
    String url = 'accounts/$accountId/khqr';
    final queryParams = <String, String>{};
    if (amount != null) queryParams['amount'] = amount.toString();
    if (bakongAccountId != null) queryParams['bakongAccountId'] = bakongAccountId;
    
    if (queryParams.isNotEmpty) {
      final queryString = Uri(queryParameters: queryParams).query;
      url = '$url?$queryString';
    }
    return get(url);
  }


  Future<void> saveFcmToken(String token) async {
    await _storage.write(key: 'fcm_token', value: token);
    final id = await getCustomerId();
    if (id != null) await put('customers/$id/fcm-token', {'fcmToken': token});
  }

  Future<String?> getFcmToken() => _storage.read(key: 'fcm_token');

  Future<Response> sendPushNotification({required String toAccountNumber, required String title, required String body, Map<String, dynamic>? data}) {
    final payload = {'toAccountNumber': toAccountNumber.trim(), 'title': title.trim(), 'body': body.trim(), if (data != null) 'data': data.map((k, v) => MapEntry(k.trim(), v?.toString().trim() ?? ""))};
    return post('notifications/push', payload);
  }

  Future<bool> refreshToken() async {
    final rt = await getRefreshToken();
    if (rt == null) return false;
    
    final res = await post('auth/refresh', {'refreshToken': rt});
    if (res.isOk && res.body != null) {
      final data = res.body;
      final token = data['token'] ?? data['access_token'] ?? data['accessToken'] ?? data['jwt'];
      final newRefreshToken = data['refreshToken'] ?? data['refresh_token'];
      
      if (token != null) { 
        await saveToken(token.toString(), refreshToken: newRefreshToken?.toString()); 
        return true; 
      }
    } else if (res.statusCode == 401) { 
      await clearAuth(); 
    }
    return false;
  }
}
