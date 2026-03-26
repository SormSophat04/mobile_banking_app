import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/network/models/transaction_model.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const Duration _transferDialogDebounce = Duration(seconds: 3);
  String? _lastTransferSignature;
  DateTime? _lastTransferHandledAt;

  static String? fcmToken; // Store token statically so it's accessible globally
  static const String _fcmTokenStorageKey = 'fcm_token';

  Future<void> initialize() async {
    try {
      // Request permission (needed for iOS)
      final permissionSettings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      log(
        'Notification permission status: ${permissionSettings.authorizationStatus}',
      );

      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      const AndroidInitializationSettings androidInitializationSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosInitializationSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings,
          );

      await _localNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          log("Notification clicked: ${response.payload}");
          _handleNotificationClick(response.payload);
        },
      );

      // Needed on Android 13+ for local notification display.
      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );

      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      // Show foreground notifications using local notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log("Received foreground message: ${message.notification?.title}");

        final notification = message.notification;
        final title = notification?.title ?? message.data['title']?.toString();
        final body = notification?.body ?? message.data['body']?.toString();
        final payloadMap = _buildPayloadFromRemoteMessage(
          message,
          fallbackTitle: title,
          fallbackBody: body,
        );

        // Show receipt dialog immediately if this is a transfer and app is open.
        _handleNotificationClick(jsonEncode(payloadMap));

        if (title != null || body != null) {
          _localNotificationsPlugin.show(
            id:
                message.messageId?.hashCode ??
                DateTime.now().millisecondsSinceEpoch.remainder(100000),
            title: title ?? 'Notification',
            body: body ?? '',
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: jsonEncode(payloadMap),
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log(
          "Notification tapped from background: ${message.notification?.title}",
        );
        final payloadMap = _buildPayloadFromRemoteMessage(
          message,
          fallbackTitle: message.notification?.title,
          fallbackBody: message.notification?.body,
        );
        _handleNotificationClick(jsonEncode(payloadMap));
      });

      final initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (initialMessage != null) {
        final payloadMap = _buildPayloadFromRemoteMessage(
          initialMessage,
          fallbackTitle: initialMessage.notification?.title,
          fallbackBody: initialMessage.notification?.body,
        );
        _handleNotificationClick(jsonEncode(payloadMap));
      }

      fcmToken ??= await _storage.read(key: _fcmTokenStorageKey);

      // Get and store FCM token
      await _cacheFcmToken(await _firebaseMessaging.getToken());
      log('FCM token ready: $fcmToken');

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        await _cacheFcmToken(newToken);
        log("FCM token refreshed");
      });
    } catch (e) {
      log("Error initializing FCM: $e");
    }
  }

  void _handleNotificationClick(String? payload) async {
    if (payload == null) return;
    try {
      final data = jsonDecode(payload);
      if (data is! Map) return;

      final payloadMap = data.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      if (!_isTransferPayload(payloadMap)) return;
      if (_isDuplicateTransfer(payloadMap)) return;

      final transactionId =
          payloadMap['transactionId']?.toString().trim() ?? '';

      final payloadTx = _buildTransactionFromPayload(payloadMap);
      TransactionModel? tx;
      if (transactionId.isNotEmpty) {
        tx = await _fetchTransactionById(transactionId);
      }
      tx = _mergeTransactions(primary: tx, fallback: payloadTx);

      if (tx != null) {
        _showReceiptDialog(tx);
      }
    } catch (e) {
      log('Error handling notification click: $e');
    }
  }

  bool _isTransferPayload(Map<String, dynamic> payload) {
    final type = payload['type']?.toString().trim().toLowerCase();
    if (type == 'transfer') return true;

    final title = payload['title']?.toString().toLowerCase() ?? '';
    final body = payload['body']?.toString().toLowerCase() ?? '';
    return title.contains('money received') ||
        body.contains('you received') ||
        title.contains('payment received');
  }

  bool _isDuplicateTransfer(Map<String, dynamic> payload) {
    final signature = [
      payload['transactionId']?.toString().trim() ?? '',
      payload['title']?.toString().trim() ?? '',
      payload['body']?.toString().trim() ?? '',
    ].join('|');

    final now = DateTime.now();
    final handledAt = _lastTransferHandledAt;
    if (_lastTransferSignature == signature &&
        handledAt != null &&
        now.difference(handledAt) < _transferDialogDebounce) {
      return true;
    }

    _lastTransferSignature = signature;
    _lastTransferHandledAt = now;
    return false;
  }

  Future<TransactionModel?> _fetchTransactionById(String transactionId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final apiClient = Get.put(ApiClient());
      final response = await apiClient.getTransaction(transactionId);
      if (!response.isOk || response.body == null) return null;

      final txMap = _extractTransactionPayload(response.body);
      if (txMap == null) return null;
      return TransactionModel.fromJson(txMap);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? _extractTransactionPayload(dynamic rawBody) {
    final decoded = _decodeIfJsonString(rawBody);
    if (decoded is! Map) return null;

    final map = decoded.map((key, value) => MapEntry(key.toString(), value));
    final wrapped =
        map['data'] ?? map['transaction'] ?? map['result'] ?? map['payload'];
    if (wrapped is Map) {
      return wrapped.map((key, value) => MapEntry(key.toString(), value));
    }
    if (wrapped is List && wrapped.isNotEmpty) {
      final first = wrapped.first;
      if (first is Map) {
        return first.map((key, value) => MapEntry(key.toString(), value));
      }
    }
    return map;
  }

  dynamic _decodeIfJsonString(dynamic rawBody) {
    if (rawBody is! String) return rawBody;
    try {
      return jsonDecode(rawBody);
    } catch (_) {
      return rawBody;
    }
  }

  TransactionModel? _buildTransactionFromPayload(Map<String, dynamic> payload) {
    final amount = _asDouble(payload['amount']) ?? 0.0;
    final title = payload['title']?.toString().trim() ?? '';

    String? senderName = _firstNonBlankText([
      payload['senderName'],
      payload['fromName'],
      payload['fromAccountName'],
      payload['fromCustomerName'],
      payload['senderFullName'],
      payload['senderDisplayName'],
      payload['fromAccountNumber'],
      payload['senderAccountNumber'],
    ]);
    if (senderName == null && title.toLowerCase().contains('from')) {
      final fromIndex = title.toLowerCase().lastIndexOf('from');
      if (fromIndex >= 0 && fromIndex + 4 < title.length) {
        senderName = _firstNonBlankText([
          title.substring(fromIndex + 4).trim(),
        ]);
      }
    }

    final status = payload['status']?.toString().trim();
    final description = payload['description']?.toString().trim();
    final reference =
        payload['referenceNumber']?.toString().trim() ??
        payload['referenceNo']?.toString().trim();
    final createAt =
        payload['createAt']?.toString().trim() ??
        payload['createdAt']?.toString().trim() ??
        DateTime.now().toIso8601String();
    final currency =
        payload['senderCurrency']?.toString().trim() ??
        payload['currency']?.toString().trim() ??
        '\$';
    final senderPhone = _firstNonBlankText([
      payload['senderPhone'],
      payload['fromPhone'],
      payload['fromPhoneNumber'],
      payload['senderPhoneNumber'],
      payload['phoneNumber'],
      payload['phone'],
    ]);

    String? senderAccountNumber = _firstNonBlankText([
      payload['senderAccountNumber'],
      payload['fromAccountNumber'],
      payload['fromAccountNo'],
      payload['senderAccountNo'],
      payload['accountNumber'],
      payload['accountNo'],
    ]);

    // Cleanup description if it's generic body notification
    String? finalDescription = (description != null && description.isNotEmpty)
        ? description
        : payload['body']?.toString().trim();

    if (finalDescription != null) {
      final lowerDesc = finalDescription.toLowerCase();
      // If description is just repeating "You received..." without unique info (except amount), we hide it
      // but only if it matches the pattern "you received ... from ..."
      if (lowerDesc.contains('you received') && lowerDesc.contains('from')) {
        // Extract account number from body if we don't have it yet
        if (senderAccountNumber == null) {
          final match = RegExp(r'from\s+([0-9]{6,20})', caseSensitive: false)
              .firstMatch(finalDescription);
          if (match != null) {
            senderAccountNumber = match.group(1);
          }
        }
      }
    }

    return TransactionModel(
      transactionId: int.tryParse(
        payload['transactionId']?.toString().trim() ??
            payload['id']?.toString().trim() ??
            '',
      ),
      amount: amount,
      description: finalDescription,
      status: (status != null && status.isNotEmpty) ? status : 'SUCCESS',
      createAt: createAt,
      referenceNumber: (reference != null && reference.isNotEmpty)
          ? reference
          : null,
      senderName: (senderName != null && senderName.isNotEmpty)
          ? senderName
          : null,
      senderPhone: senderPhone,
      senderAccountNumber: senderAccountNumber,
      senderCurrency: currency,
      currency: currency,
    );
  }

  TransactionModel? _mergeTransactions({
    required TransactionModel? primary,
    required TransactionModel? fallback,
  }) {
    if (primary == null) return fallback;
    if (fallback == null) return primary;

    primary.transactionId ??= fallback.transactionId;
    primary.amount = _mergeAmount(primary.amount, fallback.amount);
    primary.description = _firstNonBlankText([
      primary.description,
      fallback.description,
    ]);
    primary.status = _firstNonBlankText([primary.status, fallback.status]);
    primary.createAt = _firstNonBlankText([
      primary.createAt,
      fallback.createAt,
    ]);
    primary.referenceNumber = _firstNonBlankText([
      primary.referenceNumber,
      fallback.referenceNumber,
    ]);

    primary.senderName = _firstNonBlankText([
      primary.senderName,
      fallback.senderName,
      primary.receiverName,
      fallback.receiverName,
    ]);
    primary.senderPhone = _firstNonBlankText([
      primary.senderPhone,
      fallback.senderPhone,
      primary.receiverPhone,
      fallback.receiverPhone,
    ]);
    primary.senderAccountNumber = _firstNonBlankText([
      primary.senderAccountNumber,
      fallback.senderAccountNumber,
      primary.receiverAccountNumber,
      fallback.receiverAccountNumber,
    ]);

    primary.currency = _firstNonBlankText([
      primary.currency,
      primary.senderCurrency,
      fallback.currency,
      fallback.senderCurrency,
    ]);
    primary.senderCurrency = _firstNonBlankText([
      primary.senderCurrency,
      primary.currency,
      fallback.senderCurrency,
      fallback.currency,
    ]);
    primary.receiverCurrency = _firstNonBlankText([
      primary.receiverCurrency,
      fallback.receiverCurrency,
    ]);

    return primary;
  }

  double? _mergeAmount(double? primary, double? fallback) {
    if (primary != null && primary > 0) return primary;
    if (fallback != null && fallback > 0) return fallback;
    return primary ?? fallback;
  }

  double? _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  String? _firstNonBlankText(List<dynamic> values) {
    for (final value in values) {
      final normalized = value?.toString().trim();
      if (normalized == null || normalized.isEmpty) {
        continue;
      }
      final compact = normalized.toLowerCase();
      if (compact == 'null' || compact == 'n/a' || compact == 'na') {
        continue;
      }

      final words = compact.split(RegExp(r'\s+'));
      final allNullish =
          words.isNotEmpty &&
          words.every(
            (word) => word == 'null' || word == 'n/a' || word == 'na',
          );
      if (allNullish) {
        continue;
      }
      return normalized;
    }
    return null;
  }

  Map<String, dynamic> _buildPayloadFromRemoteMessage(
    RemoteMessage message, {
    String? fallbackTitle,
    String? fallbackBody,
  }) {
    final payload = <String, dynamic>{};
    message.data.forEach((key, value) {
      payload[key.toString()] = value;
    });

    final title = payload['title']?.toString().trim();
    final body = payload['body']?.toString().trim();

    if ((title == null || title.isEmpty) &&
        fallbackTitle != null &&
        fallbackTitle.trim().isNotEmpty) {
      payload['title'] = fallbackTitle.trim();
    }

    if ((body == null || body.isEmpty) &&
        fallbackBody != null &&
        fallbackBody.trim().isNotEmpty) {
      payload['body'] = fallbackBody.trim();
    }

    final type = payload['type']?.toString().trim();
    if (type == null || type.isEmpty) {
      if (_isTransferPayload(payload)) {
        payload['type'] = 'transfer';
      }
    }

    return payload;
  }

  void _showReceiptDialog(TransactionModel tx) {
    final otherName = _firstNonBlankText([tx.senderName, tx.receiverName]);
    final otherPhone = _firstNonBlankText([tx.senderPhone, tx.receiverPhone]);
    final otherAccount = _firstNonBlankText([
      tx.senderAccountNumber,
      tx.receiverAccountNumber,
    ]);

    String dateStr = '';
    if (tx.createAt != null) {
      try {
        final dt = DateTime.parse(tx.createAt!).toLocal();
        dateStr =
            '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        dateStr = tx.createAt!;
      }
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Payment Received',
                  style: AppTextStyles.title3.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              _buildRow('From', otherName ?? 'N/A'),
              SizedBox(height: 16.h),
              _buildRow('Phone number', otherPhone ?? 'N/A'),
              if (otherAccount != null) ...[
                SizedBox(height: 16.h),
                _buildRow('From Account', otherAccount),
              ],
              if (tx.referenceNumber != null) ...[
                SizedBox(height: 16.h),
                _buildRow('Code', '#${tx.referenceNumber}'),
              ],
              SizedBox(height: 16.h),
              _buildRow('Date', dateStr),
              if (tx.description != null && tx.description!.isNotEmpty) ...[
                SizedBox(height: 16.h),
                _buildRow('Description', tx.description!),
              ],
              SizedBox(height: 16.h),
              _buildRow(
                'Status',
                tx.status ?? 'SUCCESS',
                valueColor: Colors.green,
              ),
              SizedBox(height: 24.h),
              Divider(color: Colors.grey.shade300, thickness: 1),
              SizedBox(height: 24.h),
              _buildRow(
                'Amount',
                '${tx.senderCurrency ?? tx.currency ?? '\$'}${tx.amount?.toStringAsFixed(2) ?? '0.00'}',
                isTotal: true,
                valueColor: AppColors.danger,
              ),
              SizedBox(height: 32.h),
              CustomButtonPrimaryActive(
                label: 'Confirm',
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.grey,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              fontSize: isTotal ? 16.sp : 14.sp,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.body1.copyWith(
              color: valueColor ?? AppColors.black,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              fontSize: isTotal ? 20.sp : 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _cacheFcmToken(String? token) async {
    if (token == null || token.isEmpty) {
      return;
    }

    fcmToken = token;
    await _storage.write(key: _fcmTokenStorageKey, value: token);
  }
}
