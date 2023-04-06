import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/notification_controller.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/widgets/custom_alert_dialog.dart';

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
          channelDescription:
              'Notification channel to notify you when your grades change',
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
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
  }

  static Future<bool> requestUserPermissionIfNecessary() async {
    bool isAllowed = await notifications.isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await Get.dialog(
        CustomAlertDialog(
          titulo: "Activa las notificaciones",
          emoji: "🔔",
          descripcion:
              "Necesitamos tu permiso para poder enviarte notificaciones. Nada de spam, lo prometemos.",
          onCancelar: () async {
            bool isAllowed = await notifications.isNotificationAllowed();
            Get.back(result: isAllowed);
            Get.back(result: isAllowed);
          },
          onConfirmar: () async {
            await notifications.requestPermissionToSendNotifications();
            bool isAllowed = await notifications.isNotificationAllowed();
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

  static void showGradeChangeNotification(
    String title,
    String body,
    Asignatura asignatura,
  ) {
    final Map<String, String?> payload = {
      'type': 'grade_change',
      'asignatura': jsonEncode(asignatura.toJson()),
    };

    notifications.createNotification(
      content: NotificationContent(
        id: Random().nextInt(1000000),
        channelKey: gradeChangesChannelKey,
        title: title,
        body: body,
        payload: payload,
      ),
    );
  }
}
