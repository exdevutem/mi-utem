import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/screens/horario/widgets/horario_main_scroller.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/services_new/interfaces/controllers/horario_controller.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/loading_dialog.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watch_it/watch_it.dart';

class HorarioScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
  const HorarioScreen({super.key});

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {

  final ScreenshotController _screenshotController = ScreenshotController();

  final controller = di.get<HorarioController>();

  void _moveViewportToCurrentTime() {
    AnalyticsService.logEvent("horario_move_viewport_to_current_time");
    controller.moveViewportToCurrentPeriodAndDay();
  }

  void _captureAndShareScreenshot(Horario horario) async {
    showLoadingDialog(context);
    AnalyticsService.logEvent("horario_capture_and_share_screenshot");
    final horarioScroller = HorarioMainScroller(
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

    Navigator.pop(context);
    /// Share Plugin
    await Share.shareXFiles([XFile(imagePath.path)]);
  }

  @override
  void initState() {
    controller.getHorarioData().catchError((err) => {
      showErrorSnackbar(context, "Ocurrió un error al cargar el horario! Por favor intenta más tarde.")
    });
    super.initState();
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
    controller.init();

    final horario = watchValue((HorarioController controller) => controller.horario);
    final isLoadingHorario = watchValue((HorarioController controller) => controller.loadingHorario);
    final isCenteredInCurrentPeriodAndDay = watchValue((HorarioController controller) => controller.isCenteredInCurrentPeriodAndDay);


    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Horario"),
        actions: [
          horario != null ? IconButton(
            onPressed: () {
              controller.getHorarioData(forceRefresh: true).then((value) {
                setState(() {});
              });
            },
            icon: Icon(Icons.refresh_sharp),
            tooltip: "Forzar actualización del horario",
          ) : Container(),
          horario != null && !isCenteredInCurrentPeriodAndDay ? IconButton(
            onPressed: () => _moveViewportToCurrentTime(),
            icon: Icon(Icons.center_focus_strong),
            tooltip: "Centrar Horario En Hora Actual",
          ) : Container(),
          horario != null ? IconButton(
            onPressed: () => _captureAndShareScreenshot(horario),
            icon: Icon(Icons.share),
            tooltip: "Compartir Horario",
          ) : Container()
        ],
      ),
      body: ((isLoadingHorario && horario == null) || horario == null) ? Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Center(
                child: LoadingIndicator(),
              ),
            ),
          ],
        ),
      ) : Screenshot(
        controller: _screenshotController,
        child: HorarioMainScroller(
          horario: horario,
        ),
      ),
    );
  }
}
