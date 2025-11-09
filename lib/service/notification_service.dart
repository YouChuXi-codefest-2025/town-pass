import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart' show TargetPlatform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  static int _id = 0;
  static final FlutterLocalNotificationsPlugin _notificationInstance = FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    await _notificationInstance.getNotificationAppLaunchDetails();

    final InitializationSettings initializationSettings = InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
          // add action when notification clicked
        },
      ),
    );

    await _notificationInstance.initialize(initializationSettings);

    return this;
  }

  static Future<void> requestPermission() async {
    if (kIsWeb) {
      // Web 平台不支持本地通知權限請求
      return;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _notificationInstance.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _notificationInstance.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  static Future<void> showNotification({String? title, String? content}) async {
    await _notificationInstance.show(
      _id++,
      title,
      content,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'TownPass android notification id',
          'TownPass android notification channel name',
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
    );
  }
}
