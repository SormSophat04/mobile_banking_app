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

        // Show receipt dialog immediately if it's a transfer and app is open
        if (message.data['type'] == 'transfer') {
          _handleNotificationClick(jsonEncode(message.data));
        }

        final notification = message.notification;
        final title = notification?.title ?? message.data['title']?.toString();
        final body = notification?.body ?? message.data['body']?.toString();

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
            payload: jsonEncode(message.data),
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log(
          "Notification tapped from background: ${message.notification?.title}",
        );
        _handleNotificationClick(jsonEncode(message.data));
      });

      final initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationClick(jsonEncode(initialMessage.data));
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
      if (data['type'] == 'transfer' && data['transactionId'] != null) {
        final transactionId = data['transactionId'].toString();
        await Future.delayed(const Duration(milliseconds: 500));

        final apiClient = Get.put(ApiClient());
        final response = await apiClient.getTransaction(transactionId);

        if (response.isOk && response.body != null) {
          final txData = response.body;
          TransactionModel? tx;
          if (txData is String) {
            try {
              tx = TransactionModel.fromJson(jsonDecode(txData));
            } catch (_) {}
          } else if (txData is Map<String, dynamic>) {
            tx = TransactionModel.fromJson(txData);
          }
          if (tx != null) {
            _showReceiptDialog(tx);
          }
        }
      }
    } catch (e) {
      log('Error handling notification click: $e');
    }
  }

  void _showReceiptDialog(TransactionModel tx) {
    final otherName = tx.senderName;
    final otherPhone = tx.senderPhone;

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
