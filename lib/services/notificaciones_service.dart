import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
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
      isAllowed = await Get.dialog(
        Center(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Card(
                        margin: EdgeInsets.all(40),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Activa las notificaciones",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Container(height: 20),
                              Text(
                                "🔔",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 50,
                                ),
                              ),
                              Container(height: 20),
                              Text(
                                "Necesitamos tu permiso para poder enviarte notificaciones. Nada de spam, lo prometemos.",
                                textAlign: TextAlign.center,
                              ),
                              Container(height: 20),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: () async {
                                      bool isAllowed = await notification
                                          .isNotificationAllowed();
                                      Get.back(result: isAllowed);
                                    },
                                    child: Text("No permitir"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await notification
                                          .requestPermissionToSendNotifications();
                                      bool isAllowed = await notification
                                          .isNotificationAllowed();
                                      Get.back(result: isAllowed);
                                    },
                                    child: Text("Permitir"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return isAllowed;
  }
}
