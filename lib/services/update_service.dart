import 'package:flutter/scheduler.dart';

class UpdateService {

  UpdateService(){
    SchedulerBinding.instance.addPostFrameCallback((_) => _checkAndPerformUpdate());
  }

  /* try {
      VersionStatus status =
          await NewVersion(context: context).getVersionStatus();
      print("status.localVersion ${status.localVersion}");
      print("status.storeVersion ${status.storeVersion}");

      var localVersion = status.localVersion.split(".");
      var storeVersion = status.storeVersion.split(".");
      if (storeVersion[0].compareTo(localVersion[0]) > 0) {
        if (Platform.isAndroid) {
          AppUpdateInfo info = await InAppUpdate.checkForUpdate();

          if (info.updateAvailable == true) {
            await InAppUpdate.performImmediateUpdate();
          }
        }
      } else if (storeVersion[1].compareTo(localVersion[1]) > 0) {
        if (Platform.isAndroid) {
          AppUpdateInfo info = await InAppUpdate.checkForUpdate();

          if (info.updateAvailable == true) {
            await InAppUpdate.startFlexibleUpdate();
            await InAppUpdate.completeFlexibleUpdate();
          }
        }
      } else if (storeVersion[2].compareTo(localVersion[2]) > 0) {
        print("MINOR");
      }

      return;
    } catch (error) {
      print("_checkAndPerformUpdate Error: ${error.toString()}");
    } */

  Future<void> _checkAndPerformUpdate() async {

  }
}