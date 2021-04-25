import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mi_utem/models/rut.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsService {
  static AwesomeNotifications get notification => AwesomeNotifications();

  static Future initialize() async {
    try {
      FirebaseMessaging.onBackgroundMessage(_onFCM);
      await notification.initialize(null, [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: MainTheme.primaryColor,
            ledColor: MainTheme.primaryColor)
      ]);
          NotificationsService.notification.actionStream.listen((receivedNotification) {});

    NotificationsService.notification.createdStream.listen((ReceivedNotification notification) {
      print("Notification created: "+(notification.title ?? notification.body ?? notification.id.toString()));
    });

    NotificationsService.notification.displayedStream.listen((ReceivedNotification notification) {
      print("Notification displayed: "+(notification.title ?? notification.body ?? notification.id.toString()));
    });

    NotificationsService.notification.dismissedStream.listen((ReceivedAction dismissedAction) {
      print("Notification dismissed: "+(dismissedAction.title ?? dismissedAction.body ?? dismissedAction.id.toString()));
    });
      String fcmToken = await FirebaseMessaging.instance.getToken();
      print("Firebase token: $fcmToken");

    } catch (e) {
      print('Error ${e.toString()}');
    }
  }

  static Future<dynamic> _onFCM(RemoteMessage message) async {
    WidgetsFlutterBinding.ensureInitialized();
    notification.createNotification(
      content: NotificationContent(
        channelKey: "basic_channel",
        id: 1,
        title: message.notification?.title ?? "New Notification",
        body: message.notification?.body ?? "",
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'Reply',
          label: 'Reply',
          buttonType: ActionButtonType.InputField,
        ),
      ],
    );
  }

  static Future<bool> requestUserPermissionIfNecessary() async {
    bool isAllowed = await notification.isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await Get.defaultDialog(
        title: "Activa las notificaciones",
        onCancel: () async {
          bool isAllowed = await notification.isNotificationAllowed();
          Get.back(result: isAllowed);
        },
        onConfirm: () async {
          await notification.requestPermissionToSendNotifications();
          bool isAllowed = await notification.isNotificationAllowed();
          Get.back(result: isAllowed);
        },
      );
    }
    return isAllowed;
  }
}
