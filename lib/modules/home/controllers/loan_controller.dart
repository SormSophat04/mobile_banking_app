import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response;
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/network/api_provider.dart';
import 'package:mobile_banking_app/core/network/models/loan_model.dart';
import 'package:mobile_banking_app/core/utils/jwt_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LoanController extends GetxController {
  static const _storage = FlutterSecureStorage();
  final ApiClient apiClient = Get.put(ApiClient());
  final ApiProvider _apiProvider = ApiProvider();

  bool isLoading = true;
  bool isExportingByLoanId = false;
  bool isExportingByPeriod = false;
  String errorMessage = '';
  LoanModel? loan;

  @override
  void onInit() {
    super.onInit();
    fetchLoan();
  }

  Future<void> fetchLoan() async {
    isLoading = true;
    errorMessage = '';
    loan = null;
    update();

    try {
      final customerId = await _resolveCustomerId();
      if (customerId == null || customerId.trim().isEmpty) {
        isLoading = false;
        errorMessage =
            'Customer ID is unavailable. Please login again or pass customerId in route arguments.';
        update();
        return;
      }

      final response = await apiClient.get('loans/customer/$customerId');
      if (!response.isOk) {
        if (response.statusCode == 404 || response.statusCode == 204) {
          errorMessage = 'No loan found.';
        } else {
          errorMessage =
              'Failed to load loan (${response.statusCode}): ${response.bodyString ?? 'Unknown error'}';
        }
        return;
      }

      final parsedLoan =
          _parseLoanFromResponse(response.body) ?? _parseLoanFromResponse(response.bodyString);

      if (parsedLoan == null) {
        errorMessage = 'No loan data found in response.';
        return;
      }

      loan = parsedLoan;
    } catch (e) {
      errorMessage = 'Unable to fetch loan: $e';
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> refreshLoan() => fetchLoan();
  
  Future<void> exportLoanExcelByLoanId() async {
    final loanId = loan?.loanId;
    if (loanId == null) {
      Get.snackbar(
        'Export Failed',
        'No loan ID found for export.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await _exportExcelFile(
      endpoint: 'loans/$loanId/export/excel',
      fileName: 'loan_${loanId}_${_timestamp()}.xlsx',
      exportByLoanId: true,
    );
  }

  Future<void> exportLoanExcelByPeriod({
    required int year,
    required int month,
  }) async {
    if (year <= 0 || month < 1 || month > 12) {
      Get.snackbar(
        'Invalid Date',
        'Please provide a valid year and month (1-12).',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await _exportExcelFile(
      endpoint: 'loans/export/excel',
      queryParameters: {'year': year, 'month': month},
      fileName: 'loans_${year}_${month.toString().padLeft(2, '0')}_${_timestamp()}.xlsx',
      exportByLoanId: false,
    );
  }

  Future<void> _exportExcelFile({
    required String endpoint,
    required String fileName,
    required bool exportByLoanId,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (exportByLoanId) {
      isExportingByLoanId = true;
    } else {
      isExportingByPeriod = true;
    }
    update();

    try {
      final Response<dynamic> response = await _apiProvider.dio.get<dynamic>(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: const {
            'Accept':
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          },
          responseType: ResponseType.bytes,
          receiveDataWhenStatusError: true,
        ),
      );

      final status = response.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        throw Exception('HTTP $status');
      }

      final bytes = _extractBytes(response.data);
      if (bytes == null || bytes.isEmpty) {
        throw Exception('Empty file response');
      }

      final path = await _saveFile(bytes, fileName);
      Get.snackbar(
        'Export Success',
        'Excel saved to:\n$path',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = _extractServerMessage(e.response?.data);
      Get.snackbar(
        'Export Failed',
        status != null
            ? 'Unable to export Excel ($status): $message'
            : 'Unable to export Excel: ${e.message ?? message}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Export Failed',
        'Unable to export Excel: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (exportByLoanId) {
        isExportingByLoanId = false;
      } else {
        isExportingByPeriod = false;
      }
      update();
    }
  }

  Uint8List? _extractBytes(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is Uint8List) {
      return data;
    }

    if (data is List<int>) {
      return Uint8List.fromList(data);
    }

    if (data is List) {
      final casted = data.whereType<int>().toList();
      if (casted.length == data.length) {
        return Uint8List.fromList(casted);
      }
    }

    if (data is String) {
      // Some backends return base64 file content in string form.
      try {
        return base64Decode(data);
      } catch (_) {
        try {
          final parsed = jsonDecode(data);
          return _extractBytes(parsed);
        } catch (_) {
          return null;
        }
      }
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final candidate =
          map['data'] ?? map['file'] ?? map['bytes'] ?? map['content'];
      return _extractBytes(candidate);
    }

    return null;
  }

  String _extractServerMessage(dynamic data) {
    if (data == null) {
      return 'Unknown error';
    }

    if (data is String) {
      try {
        final parsed = jsonDecode(data);
        return _extractServerMessage(parsed);
      } catch (_) {
        return data;
      }
    }

    if (data is List<int>) {
      try {
        return utf8.decode(data, allowMalformed: true);
      } catch (_) {
        return 'Server returned invalid response.';
      }
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final message = map['message'] ?? map['error'] ?? map['detail'];
      if (message != null) {
        return message.toString();
      }
      return map.toString();
    }

    return data.toString();
  }

  Future<String> _saveFile(Uint8List bytes, String fileName) async {
    final directory = await _resolveExportDirectory();
    final safeName = fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final file = File('${directory.path}${Platform.pathSeparator}$safeName');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<Directory> _resolveExportDirectory() async {
    if (Platform.isAndroid) {
      final hasPermission = await _ensureAndroidDownloadPermission();
      if (!hasPermission) {
        throw Exception(
          'Storage permission denied. Please allow file access to save in Download folder.',
        );
      }

      final androidCandidates = <Directory>[
        Directory('/storage/emulated/0/Download'),
        Directory('/sdcard/Download'),
        Directory('/storage/self/primary/Download'),
      ];

      for (final candidate in androidCandidates) {
        try {
          if (await candidate.exists()) {
            return candidate;
          }
        } catch (_) {}
      }

      // Try creating the main shared Download folder on emulator/device.
      try {
        final primary = androidCandidates.first;
        await primary.create(recursive: true);
        return primary;
      } catch (_) {}

      final external = await getExternalStorageDirectory();
      if (external != null) {
        return external;
      }
    }

    try {
      final download = await getDownloadsDirectory();
      if (download != null) {
        return download;
      }
    } catch (_) {}

    return getApplicationDocumentsDirectory();
  }

  Future<bool> _ensureAndroidDownloadPermission() async {
    final manageStatus = await Permission.manageExternalStorage.status;
    if (manageStatus.isGranted) {
      return true;
    }

    final manageRequested = await Permission.manageExternalStorage.request();
    if (manageRequested.isGranted) {
      return true;
    }

    final storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) {
      return true;
    }

    final storageRequested = await Permission.storage.request();
    return storageRequested.isGranted;
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  LoanModel? _parseLoanFromResponse(dynamic source) {
    final decoded = _decodeBody(source);
    if (decoded == null) {
      return null;
    }

    if (decoded is List) {
      if (decoded.isEmpty) {
        return null;
      }
      return _parseLoanFromResponse(decoded.first);
    }

    if (decoded is Map) {
      final data = Map<String, dynamic>.from(decoded);

      if (_looksLikeLoanObject(data)) {
        return LoanModel.fromJson(data);
      }

      final nested = _findNestedLoanCandidate(data);
      if (nested == null) {
        return null;
      }
      return _parseLoanFromResponse(nested);
    }

    return null;
  }

  dynamic _decodeBody(dynamic body) {
    if (body is String) {
      try {
        return jsonDecode(body);
      } catch (_) {
        return null;
      }
    }
    return body;
  }

  bool _looksLikeLoanObject(Map<String, dynamic> json) {
    return json.containsKey('loanId') ||
        json.containsKey('loanAmount') ||
        json.containsKey('monthlyPayment');
  }

  dynamic _findNestedLoanCandidate(Map<String, dynamic> json) {
    const candidateKeys = ['data', 'result', 'loan', 'item', 'content'];
    for (final key in candidateKeys) {
      final candidate = json[key];
      if (candidate is Map || candidate is List) {
        return candidate;
      }
    }
    return null;
  }

  Future<String?> _resolveCustomerId() async {
    final fromCache = await apiClient.getCustomerId();
    if (fromCache != null && fromCache.trim().isNotEmpty) {
      return fromCache.trim();
    }

    final fromArgs = _customerIdFromArgs(Get.arguments);
    if (fromArgs != null && fromArgs.isNotEmpty) {
      await apiClient.saveCustomerId(fromArgs);
      return fromArgs;
    }

    final token = await _storage.read(key: 'jwt_token');
    if (token == null || token.trim().isEmpty) {
      return kDebugMode ? '1' : null;
    }

    final payload = JwtDecoder.decode(token);
    if (payload == null) {
      return kDebugMode ? '1' : null;
    }

    final dynamic customer = payload['customer'] ?? payload['user'] ?? payload;
    final dynamic id =
        customer is Map
            ? customer['customerId'] ?? customer['id'] ?? payload['sub']
            : payload['sub'];

    if (id == null) {
      return kDebugMode ? '1' : null;
    }

    final normalized = id.toString().trim();
    if (normalized.isEmpty) {
      return kDebugMode ? '1' : null;
    }

    await apiClient.saveCustomerId(normalized);
    return normalized;
  }

  String? _customerIdFromArgs(dynamic args) {
    if (args == null) {
      return null;
    }

    if (args is int) {
      return args.toString();
    }

    if (args is String) {
      final normalized = args.trim();
      if (normalized.isNotEmpty && int.tryParse(normalized) != null) {
        return normalized;
      }
      return null;
    }

    if (args is Map) {
      final dynamic value = args['customerId'] ?? args['id'];
      if (value != null) {
        final normalized = value.toString().trim();
        if (normalized.isNotEmpty) {
          return normalized;
        }
      }
    }

    return null;
  }
}
