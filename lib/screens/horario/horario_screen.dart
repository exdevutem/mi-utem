import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/horario_controller.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/screens/horario/widgets/horario_main_scroller.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HorarioScreen extends StatelessWidget {
  HorarioScreen({
    Key? key,
  }) : super(key: key);

  final ScreenshotController _screenshotController = ScreenshotController();

  final HorarioController controller = Get.put(HorarioController());

  CustomAppBar get _appBar => CustomAppBar(
        title: Text("Horario"),
        actions: [
          Obx(
            () => controller.horario.value != null &&
                    !controller.isCenteredInCurrentPeriodAndDay.value
                ? IconButton(
                    onPressed: () => _moveViewportToCurrentTime(),
                    icon: Icon(Icons.center_focus_strong),
                  )
                : Container(),
          ),
          Obx(
            () => controller.horario.value != null
                ? IconButton(
                    onPressed: () =>
                        _captureAndShareScreenshot(controller.horario.value!),
                    icon: Icon(Icons.share),
                  )
                : Container(),
          )
        ],
      );

  void _moveViewportToCurrentTime() {
    AnalyticsService.logEvent("horario_move_viewport_to_current_time");
    controller.moveViewportToCurrentPeriodAndDay();
  }

  void _captureAndShareScreenshot(Horario horario) async {
    AnalyticsService.logEvent("horario_capture_and_share_screenshot");
    final horarioScroller = HorarioMainScroller(
      controller: controller,
      horario: horario,
      showActive: false,
    );
    final image = await _screenshotController.captureFromWidget(
      horarioScroller.basicHorario,
      targetSize:
          Size(HorarioMainScroller.totalWidth, HorarioMainScroller.totalHeight),
    );

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File('${directory.path}/horario.png').create();
    await imagePath.writeAsBytes(image);

    /// Share Plugin
    await Share.shareXFiles([XFile(imagePath.path)]);
  }

  @override
  Widget build(BuildContext context) {
    ReviewService.addScreen("HorarioScreen");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      appBar: _appBar,
      body: Obx(
        () {
          if ((controller.loadingHorario.value &&
                  controller.horario.value == null) ||
              controller.horario.value == null) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: LoadingIndicator(),
                    ),
                  ),
                ],
              ),
            );
          }

          return Screenshot(
            controller: _screenshotController,
            child: HorarioMainScroller(
              controller: controller,
              horario: controller.horario.value!,
            ),
          );
        },
      ),
    );
  }
}

class HorarioBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HorarioController>(HorarioController(), permanent: true);
  }
}
