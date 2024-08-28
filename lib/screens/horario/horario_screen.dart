import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/horario_controller.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';
import 'package:mi_utem/core/models/horario.dart';
import 'package:mi_utem/screens/horario/widgets/horario_main_scroller.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading/loading_dialog.dart';
import 'package:mi_utem/widgets/loading/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HorarioScreen extends StatefulWidget {
  const HorarioScreen({super.key});

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {

  final ScreenshotController _screenshotController = ScreenshotController();

  bool _forceRefresh = false;
  final horarioController = Get.find<HorarioController>();

  @override
  void initState() {
    ReviewService.addScreen("HorarioScreen");
    _forceRefresh = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    horarioController.init(context);
    return FutureBuilder<Horario?>(
      future: () async {
        _moveViewportToCurrentTime();
        final data = await horarioController.getHorario(forceRefresh: _forceRefresh);
        _forceRefresh = false;
        return data;
      }(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: CustomAppBar(
              title: Text("Horario"),
            ),
            body: LoadingIndicator.centeredDefault(),
          );
        }

        final horario = snapshot.data;
        final esErrorOffline = snapshot.hasError && snapshot.error is DioError && (snapshot.error as DioError).type == DioErrorType.cancel && (snapshot.error as DioError).response?.extra["offline"] == true;
        if((snapshot.hasError && !esErrorOffline) || !snapshot.hasData || horario == null) {
          String errorMessage = "Ocurrió un error al cargar el horario! Por favor intenta más tarde.";
          final error = snapshot.error;
          if(error != null) {
            errorMessage = error is CustomException ? error.message : "Ocurrió un error al cargar el horario! Por favor intenta más tarde.";
          }

          return Scaffold(
            appBar: CustomAppBar(
              title: Text("Horario"),
              actions: [
                IconButton(
                  onPressed: _reloadData,
                  icon: Icon(Icons.refresh_sharp),
                  tooltip: "Forzar actualización del horario",
                )
              ],
            ),
            body: Center(
              child: CustomErrorWidget(
                title: "Error al cargar el horario",
                error: errorMessage,
              ),
            ),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(
            title: Text("Horario"),
            actions: [
              IconButton(
                onPressed: _reloadData,
                icon: Icon(Icons.refresh_sharp),
                tooltip: "Forzar actualización del horario",
              ),
              Obx(() => !horarioController.isCenteredInCurrentPeriodAndDay.value ? IconButton(
                onPressed: _moveViewportToCurrentTime,
                icon: Icon(Icons.center_focus_strong),
                tooltip: "Centrar Horario En Hora Actual",
              ) : Container()),
              IconButton(
                onPressed: () => _captureAndShareScreenshot(horario),
                icon: Icon(Icons.share),
                tooltip: "Compartir Horario",
              )
            ],
          ),
          body: SafeArea(
            bottom: false,
            child: Screenshot(
              controller: _screenshotController,
              child: HorarioMainScroller(
                horario: horario,
              ),
            ),
          ),
        );
      },
    );
  }

  void _moveViewportToCurrentTime() {
    AnalyticsService.logEvent("horario_move_viewport_to_current_time");
    horarioController.moveViewportToCurrentPeriodAndDay(context);
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
      targetSize: Size(HorarioMainScroller.totalWidth, HorarioMainScroller.totalHeight),
    );

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File('${directory.path}/horario.png').create();
    await imagePath.writeAsBytes(image);

    Navigator.pop(context);
    /// Share Plugin
    await Share.shareXFiles([XFile(imagePath.path)]);
  }

  void _reloadData() => setState(() => _forceRefresh = true);
}
