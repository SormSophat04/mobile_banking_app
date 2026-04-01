import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiProvider {
  static const _storage = FlutterSecureStorage();
  late final Dio dio;

  // Singleton pattern
  ApiProvider._internal() {
    dio = _createDio();
  }
  static final ApiProvider _instance = ApiProvider._internal();
  factory ApiProvider() => _instance;

  Dio _createDio() {
    final baseUrl = !kIsWeb && Platform.isAndroid 
        ? 'http://10.0.2.2:8080/api/' 
        : 'http://localhost:8080/api/';

    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    ));

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'jwt_token');
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
      ),
      _ErrorInterceptor(),
    ]);

    return dio;
  }

  // Concise HTTP methods
  Future<Response> get(String path, {Map<String, dynamic>? query}) => dio.get(path, queryParameters: query);
  Future<Response> post(String path, {dynamic data}) => dio.post(path, data: data);
  Future<Response> put(String path, {dynamic data}) => dio.put(path, data: data);
  Future<Response> patch(String path, {dynamic data}) => dio.patch(path, data: data);
  Future<Response> delete(String path, {dynamic data}) => dio.delete(path, data: data);
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = 'Something went wrong';
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timed out';
        break;
      case DioExceptionType.badResponse:
        String? serverMessage;
        final data = err.response?.data;

        if (data is Map) {
          final map = Map<String, dynamic>.from(data);
          serverMessage =
              map['message']?.toString() ??
              map['error']?.toString() ??
              map['detail']?.toString();
        } else if (data is String && data.trim().isNotEmpty) {
          serverMessage = data.trim();
        } else if (data is List<int> && data.isNotEmpty) {
          try {
            serverMessage = utf8.decode(data, allowMalformed: true).trim();
          } catch (_) {
            serverMessage = null;
          }
        }

        message = switch (err.response?.statusCode) {
          400 => 'Invalid request',
          401 => 'Unauthorized access',
          404 => 'Resource not found',
          409 => 'Conflict occurred',
          500 => 'Internal server error',
          _ => serverMessage ?? 'Error ${err.response?.statusCode}',
        };
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;
      default:
        break;
    }
    
    return handler.next(err.copyWith(message: message));
  }
}

// Minimalist exception if needed, though DioException is often enough
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}
