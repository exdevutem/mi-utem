import 'dart:convert';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/main.dart';
import 'package:mi_utem/models/asignaturas/asignatura.dart';
import 'package:mi_utem/screens/asignatura/asignatura_detalle_screen.dart';
import 'package:mi_utem/services/analytics_service.dart';

class NotificationController {
  /// Use this method to detect when a new notifications or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    log("onNotificationCreatedMethod: ${receivedNotification.id}");
  }

  /// Use this method to detect every time that a new notifications is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    log("onNotificationDisplayedMethod: ${receivedNotification.id}");
  }

  /// Use this method to detect if the user dismissed a notifications
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notifications or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    log("onActionReceivedMethod: ${receivedAction.id} ${receivedAction.payload}");

    AnalyticsService.logEvent(
      'notification_tap',
    );

    final payload = receivedAction.payload;
    final type = payload?['type'];

    if (type == 'grade_change') {
      final asignaturaJsonString = payload?['asignatura'];
      if (asignaturaJsonString != null) {
        AnalyticsService.logEvent('notification_tap_grade_change');
        final asignatura = Asignatura.fromJson(jsonDecode(asignaturaJsonString));
        navigatorKey.currentState?.push(MaterialPageRoute(builder: (ctx) => AsignaturaDetalleScreen(asignatura: asignatura)));
      }
    }
  }

  ///  *********************************************
  ///     REMOTE NOTIFICATION EVENTS
  ///  *********************************************

  /// Use this method to execute on background when a silent data arrives
  /// (even while terminated)
  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    print('"SilentData": ${silentData.toString()}');

    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      print("bg");
    } else {
      print("FOREGROUND");
    }
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    debugPrint('FCM Token:"$token"');
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    debugPrint('Native Token:"$token"');
  }
}
