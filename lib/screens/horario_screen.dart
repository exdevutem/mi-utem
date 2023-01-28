import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/horario_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vector_math/vector_math_64.dart';

import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/bloque_dias_card.dart';
import 'package:mi_utem/widgets/bloque_periodo_card.dart';
import 'package:mi_utem/widgets/bloque_ramo_card.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';

class HorarioScreen extends GetView<HorarioController> {
  HorarioScreen({
    Key? key,
  }) : super(key: key);

  final double _classBlockWidth = 290.0;
  final double _classBlockHeight = 180.0;
  final double _dayBlockHeight = 50.0;
  final double _dayBlockWidth = 320.0;
  final double _periodBlockHeight = 200.0;
  final double _periodBlockWidth = 65.0;
  final bool _dayActive = true;
  final bool _periodActive = true;

  final TransformationController? _controller = TransformationController();
  final FirebaseRemoteConfig? _remoteConfig = ConfigService.config;
  final ScreenshotController _screenshotController = ScreenshotController();

  CustomAppBar get _appBar => CustomAppBar(
        title: Text("Horario"),
        actions: [
          Obx(
            () => controller.horario.value != null
                ? IconButton(
                    onPressed: () {
                      _screenshotController
                          .capture(delay: const Duration(milliseconds: 10))
                          .then((Uint8List? image) async {
                        if (image != null) {
                          final directory =
                              await getApplicationDocumentsDirectory();
                          final imagePath =
                              await File('${directory.path}/horario.png')
                                  .create();
                          await imagePath.writeAsBytes(image);

                          /// Share Plugin
                          await Share.shareXFiles([XFile(imagePath.path)]);
                        }
                      }).catchError((onError) {
                        print(onError);
                      });
                    },
                    icon: Icon(Icons.share),
                  )
                : Container(),
          )
        ],
      );

  List<TableRow> _getChildren(Horario horario) {
    List<TableRow> filas = [];

    // Container vacio para la esquina superior izquierda
    List<Widget> filaWidgets = [
      Container(
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          border: Border(
            right: BorderSide(
              color: Color(0xFFBDBDBD),
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
        ),
        height: _dayBlockHeight,
        width: _periodBlockWidth,
      )
    ];

    // Primera fila de los días
    for (dynamic dia in horario.diasHorario) {
      filaWidgets.add(BloqueDiasCard(
        day: dia,
        height: _dayBlockHeight,
        width: _dayBlockWidth,
        active: _dayActive,
      ));
    }
    filas.add(TableRow(children: filaWidgets));

    // Se llena el resto
    for (num bloque = 0; bloque < horario.horarioEnlazado.length; bloque++) {
      filaWidgets = [];

      if ((bloque % 2) == 0) {
        filaWidgets.add(BloquePeriodoCard(
          inicio: horario.horasInicio[bloque ~/ 2],
          intermedio: horario.horasIntermedio[bloque ~/ 2],
          fin: horario.horasTermino[bloque ~/ 2],
          height: _periodBlockHeight,
          width: _periodBlockWidth,
          active: _periodActive,
        ));
        List<BloqueHorario> bloquePorDias =
            horario.horarioEnlazado[bloque as int];
        for (num dia = 0; dia < bloquePorDias.length; dia++) {
          BloqueHorario _bloque = horario.horarioEnlazado[bloque][dia as int];

          filaWidgets.add(BloqueRamoCard(
            height: _classBlockHeight,
            width: _classBlockWidth,
            bloque: _bloque,
          ));
        }
        filas.add(TableRow(children: filaWidgets));
      }
    }

    return filas;
  }

  Future<void> _onRefresh() async {
    await controller.getHorarioData();
  }

  @override
  Widget build(BuildContext context) {
    double zoom = _remoteConfig!.getDouble(ConfigService.HORARIO_ZOOM);
    _controller!.value = Matrix4.identity();
    _controller!.value.setDiagonal(Vector4(zoom, zoom, zoom, 1));

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
      body: Obx(() {
        if (controller.loadingHorario.value ||
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
          child: InteractiveViewer(
            transformationController: _controller,
            maxScale: 1,
            minScale: 0.1,
            panAxis: PanAxis.aligned,
            clipBehavior: Clip.none,
            constrained: false,
            onInteractionUpdate: (interaction) {},
            child: Screenshot(
              controller: _screenshotController,
              child: SafeArea(
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(_classBlockWidth),
                  columnWidths: {
                    0: FixedColumnWidth(_periodBlockWidth),
                  },
                  children: _getChildren(controller.horario.value!),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class HorarioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HorarioController>(() => HorarioController());
  }
}
