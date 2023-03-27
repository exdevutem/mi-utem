import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/services/horarios_service.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class HorarioController extends GetxController {
  static const startTime = "7:55";
  static const periodDuration = Duration(minutes: 90);
  static const periodGap = Duration(minutes: 5);

  static final GetStorage _box = GetStorage();
  static final List<Color> _randomColors = Colors.primaries.toList()..shuffle();

  final horario = Rxn<Horario>(null);
  final loadingHorario = false.obs;
  final usedColors = <Color>[];
  final zoom = 0.5.obs;

  final blockContentController = TransformationController();
  final daysHeaderController = TransformationController();
  final periodHeaderController = TransformationController();
  final cornerController = TransformationController();

  static HorarioController get to => Get.find();

  List<Color> get unusedColors {
    List<Color> availableColors = [..._randomColors];
    availableColors.retainWhere((Color color) => !usedColors.contains(color));
    if (availableColors.length == 0) {
      return [..._randomColors];
    }
    return availableColors;
  }

  DateTime _now = DateTime.parse("2023-03-27 09:45:00");

  double get minutesFromStart {
    final now = _now;
    final startTimeParts = startTime.split(":");
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(startTimeParts[0]),
      int.parse(startTimeParts[1]),
    );
    return now.difference(startDateTime).inMinutes.toDouble();
  }

  int get indexOfCurrentDayStartingAtMonday {
    final now = _now;
    final day = now.weekday;
    return day - 1;
  }

  int? get indexOfCurrentPeriod {
    final minutes = minutesFromStart;
    final periodBlockDuration =
        periodDuration.inMinutes + (periodGap.inMinutes * 2);

    final period = minutes ~/ periodBlockDuration;
    final minutesModule = minutes % periodBlockDuration;

    log("minutes $minutes period $period minutesModule: $minutesModule periodBlockDuration: $periodBlockDuration periodGap: ${periodGap.inMinutes} other ${periodBlockDuration - periodGap.inMinutes}");

    if (minutesModule >= periodGap.inMinutes &&
        minutesModule <= (periodBlockDuration - periodGap.inMinutes)) {
      return period;
    }

    return null;
  }

  @override
  onInit() {
    getHorarioData();
    _init();
    super.onInit();
  }

  void _init() {
    _initController(blockContentController);
    _initController(daysHeaderController);
    _initController(periodHeaderController);
    _initController(cornerController);

    _setScrollControllerListeners();
  }

  Future<void> getHorarioData() async {
    loadingHorario.value = true;
    horario.value = await HorarioService.getHorario();
    _setRandomColorsByHorario();
    loadingHorario.value = false;
  }

  void _setRandomColorsByHorario() {
    if (horario.value?.horario != null) {
      for (var dia in horario.value!.horario!) {
        for (var bloque in dia) {
          if (bloque.asignatura != null) {
            addAsignaturaAndSetColor(bloque.asignatura!);
          }
        }
      }
    }
  }

  void _setScrollControllerListeners() {
    blockContentController.addListener(() {
      final xPosition = blockContentController.value.getTranslation().x;
      final yPosition = blockContentController.value.getTranslation().y;
      final currentZoom = blockContentController.value.getMaxScaleOnAxis();

      daysHeaderController.value.setTranslationRaw(xPosition, 0, 0);
      periodHeaderController.value.setTranslationRaw(0, yPosition, 0);

      daysHeaderController.value.setDiagonal(
        vector.Vector4(currentZoom, currentZoom, currentZoom, 1),
      );
      periodHeaderController.value.setDiagonal(
        vector.Vector4(currentZoom, currentZoom, currentZoom, 1),
      );
      cornerController.value.setDiagonal(
        vector.Vector4(currentZoom, currentZoom, currentZoom, 1),
      );

      zoom.value = currentZoom;
    });

    daysHeaderController.addListener(() {
      final xPosition = daysHeaderController.value.getTranslation().x;
      final currentZoom = daysHeaderController.value.getMaxScaleOnAxis();

      final contentYPosition = blockContentController.value.getTranslation().y;

      blockContentController.value
          .setTranslationRaw(xPosition, contentYPosition, 0);

      blockContentController.value.setDiagonal(
        vector.Vector4(currentZoom, currentZoom, currentZoom, 1),
      );
      periodHeaderController.value.setDiagonal(
        vector.Vector4(currentZoom, currentZoom, currentZoom, 1),
      );
      cornerController.value.setDiagonal(
        vector.Vector4(currentZoom, currentZoom, currentZoom, 1),
      );

      zoom.value = currentZoom;
    });

    periodHeaderController.addListener(() {
      final yPosition = periodHeaderController.value.getTranslation().y;
      final currentZoom = periodHeaderController.value.getMaxScaleOnAxis();

      final contentXPosition = blockContentController.value.getTranslation().x;

      periodHeaderController.value.setTranslationRaw(0, yPosition, 0);

      blockContentController.value
          .setTranslationRaw(contentXPosition, yPosition, 0);

      blockContentController.value.setDiagonal(
        vector.Vector4(currentZoom, currentZoom, currentZoom, 1),
      );
      daysHeaderController.value.setDiagonal(
        vector.Vector4(currentZoom, currentZoom, currentZoom, 1),
      );
      cornerController.value.setDiagonal(
        vector.Vector4(currentZoom, currentZoom, currentZoom, 1),
      );

      zoom.value = currentZoom;
    });
  }

  void _initController(TransformationController controller) {
    controller.value = Matrix4.identity();
    controller.value
        .setDiagonal(vector.Vector4(zoom.value, zoom.value, zoom.value, 1));
  }

  void addAsignaturaAndSetColor(Asignatura asignatura, {Color? color}) {
    bool hasColor = getColor(asignatura) != null;
    if (!hasColor) {
      Color? newColor = color ?? unusedColors[0];
      _setColor(asignatura, newColor);
    }
  }

  Color? getColor(Asignatura asignatura) {
    String key = '${asignatura.codigo}_${asignatura.tipoHora}';
    int? colorValue = _box.read(key);
    return colorValue != null ? Color(colorValue) : null;
  }

  void _setColor(Asignatura asignatura, Color color) {
    String key = '${asignatura.codigo}_${asignatura.tipoHora}';
    usedColors.add(color);
    _box.write(key, color.value);
  }
}
