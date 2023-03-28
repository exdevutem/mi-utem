import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/horario_controller.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/screens/horario/widgets/horario_main_scroller.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';
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
                        _captureScreenshot(controller.horario.value!),
                    icon: Icon(Icons.share),
                  )
                : Container(),
          )
        ],
      );

  void _moveViewportToCurrentTime() {
    controller.moveViewportToCurrentPeriodAndDay();
  }

  void _captureScreenshot(Horario horario) async {
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

  Future<void> _onRefresh() async {
    await controller.getHorarioData();
  }

  @override
  Widget build(BuildContext context) {
    controller.getHorarioData();

    ReviewService.addScreen("HorarioScreen");
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'HorarioScreen');
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

          return PullToRefresh(
            onRefresh: () async {
              await _onRefresh();
            },
            child: Screenshot(
              controller: _screenshotController,
              child: HorarioMainScroller(
                controller: controller,
                horario: controller.horario.value!,
              ),
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
    Get.lazyPut<HorarioController>(() => HorarioController());
  }
}
