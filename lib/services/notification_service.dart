import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/controllers/notification_controller.dart';
import 'package:mi_utem/core/models/asignaturas/asignatura.dart';
import 'package:mi_utem/core/models/carrera.dart';

class NotificationService {
  static const announcementsChannelKey = 'announcements_channel';
  static const gradeChangesChannelKey = 'grade_channel';

  static AwesomeNotifications get notifications => AwesomeNotifications();
  static AwesomeNotificationsFcm get fcm => AwesomeNotificationsFcm();

  static Future initialize() async {
    await fcm.initialize(
      onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
      onFcmTokenHandle: NotificationController.myFcmTokenHandle,
      onNativeTokenHandle: NotificationController.myNativeTokenHandle,
      debug: true,
    );

    notifications.initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'announcements',
          channelKey: announcementsChannelKey,
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic announcements',
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelGroupKey: 'grade_changes',
          channelKey: gradeChangesChannelKey,
          channelName: 'Grades changes',
          channelDescription: 'Notification channel to notify you when your grades change',
          channelShowBadge: true,
          importance: NotificationImportance.High,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'announcements',
          channelGroupName: 'Announcements',
        ),
        NotificationChannelGroup(
          channelGroupKey: 'grade_changes',
          channelGroupName: 'Grade changes',
        ),
      ],
      debug: true,
    );

    notifications.setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );
  }

  static Future<bool> hasAllowedNotifications() async => await notifications.isNotificationAllowed();

  static Future<bool> requestUserPermissionIfNecessary(BuildContext context) async {
    bool isAllowed = await hasAllowedNotifications();
    if (!isAllowed) {
      await notifications.requestPermissionToSendNotifications();
      isAllowed = await notifications.isNotificationAllowed();
    }
    return isAllowed;
  }

  static void showAnnouncementNotification({
    required String title,
    required String body,
    Map<String, dynamic> payload = const {},
  }) async {
    if(!await hasAllowedNotifications()) {
      return;
    }

    notifications.createNotification(content: NotificationContent(
      id: payload.hashCode,
      channelKey: announcementsChannelKey,
      title: title,
      body: body,
      payload: {
        'type': 'announcement',
        ...payload,
      },
    ));
  }

  static void showGradeChangeNotification({
    required String title,
    required String body,
    required Carrera carrera,
    required Asignatura asignatura,
  }) async {
    if(!await hasAllowedNotifications()) {
      return;
    }

    notifications.createNotification(content: NotificationContent(
      id: asignatura.hashCode,
      channelKey: gradeChangesChannelKey,
      title: title,
      body: body,
      payload: {
        'type': 'grade_change',
        'asignatura': asignatura.toString(),
        'carrera': carrera.toString(),
      },
    ));
  }
}
