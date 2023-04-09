import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:mi_utem/controllers/grades_changes_controller.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class BackgroundController {
// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
  @pragma('vm:entry-point')
  static void backgroundFetchHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    if (isTimeout) {
      BackgroundFetch.finish(taskId);
      return;
    }
    BackgroundFetch.finish(taskId);
  }
}

class BackgroundService {
  static Future<void> initAndStart() async {
    BackgroundFetch.registerHeadlessTask(
      BackgroundController.backgroundFetchHeadlessTask,
    );

    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 30,
        startOnBoot: true,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,
      ),
      (String taskId) async {
        await GradesChangesController.checkIfGradesHasChange();

        BackgroundFetch.finish(taskId);
      },
      (String taskId) async {
        Sentry.captureMessage(
          "BackgroundFetch task timeout $taskId",
          level: SentryLevel.warning,
        );
        BackgroundFetch.finish(taskId);
      },
    );

    BackgroundFetch.start().then((int status) {}).catchError((e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
    });
  }
}
