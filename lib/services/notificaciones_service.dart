import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/custom_alert_dialog.dart';

class NotificationsService {
  static AwesomeNotifications get notification => AwesomeNotifications();

  static Future initialize() async {
    try {
      FirebaseMessaging.onBackgroundMessage(_onFCM);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        await notification.createNotification(
          content: NotificationContent(
            id: 0,
            channelKey: "basic_channel",
            title: message.notification?.title ?? "",
            body: message.notification?.body ?? "",
          ),
        );
      });
      await notification.initialize(
        null,
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: MainTheme.primaryColor,
              ledColor: MainTheme.primaryColor)
        ],
      );
      NotificationsService.notification.actionStream
          .listen((receivedNotification) {});

      NotificationsService.notification.createdStream
          .listen((ReceivedNotification notification) {
        print("Notification created: " +
            (notification.title ??
                notification.body ??
                notification.id.toString()));
      });

      NotificationsService.notification.displayedStream
          .listen((ReceivedNotification notification) {
        print("Notification displayed: " +
            (notification.title ??
                notification.body ??
                notification.id.toString()));
      });

      NotificationsService.notification.dismissedStream
          .listen((ReceivedAction dismissedAction) {
        print("Notification dismissed: " +
            (dismissedAction.title ??
                dismissedAction.body ??
                dismissedAction.id.toString()));
      });
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      print("Firebase token: $fcmToken");
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }

  static Future<dynamic> _onFCM(RemoteMessage message) async {
    WidgetsFlutterBinding.ensureInitialized();
    log("Notification received");
    /* notification.createNotification(
      content: NotificationContent(
        channelKey: "basic_channel",
        id: 1,
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
      ),
    ); */
  }

  static Future<bool> requestUserPermissionIfNecessary() async {
    bool isAllowed = await notification.isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await Get.dialog(
        CustomAlertDialog(
          titulo: "Activa las notificaciones",
          emoji: "🔔",
          descripcion:
              "Necesitamos tu permiso para poder enviarte notificaciones. Nada de spam, lo prometemos.",
          onCancelar: () async {
            bool isAllowed = await notification.isNotificationAllowed();
            Get.back(result: isAllowed);
            Get.back(result: isAllowed);
          },
          onConfirmar: () async {
            await notification.requestPermissionToSendNotifications();
            bool isAllowed = await notification.isNotificationAllowed();
            Get.back(result: isAllowed);
            Get.back(result: isAllowed);
          },
          cancelarTextoBoton: "No permitir",
          confirmarTextoBoton: "Permitir",
        ),
      );
    }
    return isAllowed;
  }
}
