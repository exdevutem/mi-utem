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
      // This task has exceeded its allowed running-time.
      // You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] Headless task timed-out: $taskId");
      BackgroundFetch.finish(taskId);
      return;
    }
    print('[BackgroundFetch] Headless event received.');
    // Do your work here...
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
        Sentry.captureMessage(
          "BackgroundFetch event received $taskId",
          level: SentryLevel.debug,
        );

        await GradesChangesController.checkIfGradesHasChange();

        BackgroundFetch.finish(taskId);
      },
      (String taskId) async {
        Sentry.captureMessage(
          "BackgroundFetch task timeout $taskId",
          level: SentryLevel.warning,
        );
        print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
        BackgroundFetch.finish(taskId);
      },
    );

    BackgroundFetch.start().then((int status) {
      Sentry.captureMessage(
        "BackgroundFetch start success with status $status",
        level: SentryLevel.debug,
      );
    }).catchError((e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
    });
  }
}
