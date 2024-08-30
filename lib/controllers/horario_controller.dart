import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/core/models/asignaturas/asignatura.dart';
import 'package:mi_utem/core/models/horario.dart';
import 'package:mi_utem/core/services/horario_service.dart';
import 'package:mi_utem/core/utils/utils.dart';
import 'package:mi_utem/screens/horario/widgets/horario_main_scroller.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class HorarioController {
  final _storage = GetStorage();
  final _randomColors = Colors.primaries.toList()..shuffle();
  final _now = DateTime.now();

  num daysCount = 6;

  num periodsCount = 9;

  String startTime = "7:55";

  Duration periodDuration = Duration(minutes: 90);

  Duration periodGap = Duration(minutes: 5);

  List<Color> usedColors = [];

  RxDouble zoom = 0.5.obs;

  RxBool indicatorIsOpen = false.obs;

  RxBool isCenteredInCurrentPeriodAndDay = false.obs;

  TransformationController blockContentController = TransformationController();

  TransformationController daysHeaderController = TransformationController();

  TransformationController periodHeaderController = TransformationController();

  TransformationController cornerController = TransformationController();

  Function? _onUpdate;

  List<Color> get unusedColors {
    List<Color> availableColors = [..._randomColors].where((Color color) => !usedColors.contains(color)).toList();
    return availableColors.isEmpty ? [..._randomColors] : availableColors;
  }

  double get minutesFromStart => _now.difference(DateTime(_now.year, _now.month, _now.day, int.parse(startTime.split(":")[0]), int.parse(startTime.split(":")[1]))).inMinutes.toDouble();

  int? get indexOfCurrentDayStartingAtMonday => _now.weekday > daysCount ? null : _now.weekday - 1;

  int? get indexOfCurrentPeriod {
    final periodBlockDuration = periodDuration.inMinutes + (periodGap.inMinutes * 2);

    final minutesModule = minutesFromStart % periodBlockDuration;

    if (minutesModule >= periodGap.inMinutes && minutesModule <= (periodBlockDuration - periodGap.inMinutes)) {
      return (minutesFromStart ~/ periodBlockDuration); // Periodo actual
    }

    return null;
  }

  void init(BuildContext context) {
    zoom.value = RemoteConfigService.horarioZoom;
    moveViewportToCurrentPeriodAndDay(context);
    setZoom(zoom.value);

    _setScrollControllerListeners();
  }

  Future<Horario> getHorario({ bool forceRefresh = false }) async {
    final horario = await Get.find<HorarioService>().getHorario(forceRefresh: forceRefresh);
    _setRandomColorsByHorario(horario);
    return horario;
  }

  void moveViewportTo(BuildContext context, double x, double y) {
    final viewportWidth = MediaQuery.of(context).size.width - MediaQuery.of(context).padding.horizontal;
    final viewportHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical;

    x = (x + (HorarioMainScroller.periodWidth / 2)) * zoom.value - (viewportWidth / 2);
    y = (y + (HorarioMainScroller.dayHeight / 2)) * zoom.value - (viewportHeight / 2);

    x = x < 0 ? 0 : x;
    y = y < 0 ? 0 : y;

    final maxXPosition = (HorarioMainScroller.daysWidth + HorarioMainScroller.periodWidth) * zoom.value - viewportWidth;
    final maxYPosition = (HorarioMainScroller.periodsHeight + HorarioMainScroller.dayHeight) * zoom.value - viewportHeight + kToolbarHeight;

    x = x > maxXPosition ? maxXPosition : x;
    y = y > maxYPosition ? maxYPosition : y;

    blockContentController.value = blockContentController.value..setTranslationRaw(-x, -y, 0);
    periodHeaderController.value = periodHeaderController.value..setTranslationRaw(0, -y, 0);
    daysHeaderController.value = daysHeaderController.value..setTranslationRaw(-x, 0, 0);

    _onChangeAnyController();
  }

  void moveViewportToPeriodIndexAndDayIndex(BuildContext context, int periodIndex, int dayIndex) {
    final blockWidth = HorarioMainScroller.blockWidth;
    final x = (dayIndex * blockWidth) + (blockWidth / 2);

    final blockHeight = HorarioMainScroller.blockHeight;
    final y = (periodIndex * blockHeight) + (blockHeight / 2);

    moveViewportTo(context, x, y);
  }

  void moveViewportToCurrentPeriodAndDay(BuildContext context) {
    final periodIndex = indexOfCurrentPeriod ?? 0;
    final dayIndex = indexOfCurrentDayStartingAtMonday ?? 0;

    moveViewportToPeriodIndexAndDayIndex(context, periodIndex, dayIndex);

    isCenteredInCurrentPeriodAndDay.value = true;
  }

  void setZoom(double zoom) {
    blockContentController.value = blockContentController.value..setDiagonal(vector.Vector4(zoom, zoom, zoom, 1));
    periodHeaderController.value = periodHeaderController.value..setDiagonal(vector.Vector4(zoom, zoom, zoom, 1));
    daysHeaderController.value = daysHeaderController.value..setDiagonal(vector.Vector4(zoom, zoom, zoom, 1));
    cornerController.value = cornerController.value..setDiagonal(vector.Vector4(zoom, zoom, zoom, 1));

    _onChangeAnyController();
  }

  void addAsignaturaAndSetColor(Asignatura asignatura, {Color? color}) {
    bool hasColor = getColor(asignatura) != null;
    if (hasColor) {
      return;
    }

    final _newColor = color ?? unusedColors[0];
    final _key = '${asignatura.codigo}_${asignatura.tipoHora}';
    usedColors.add(_newColor);
    _storage.write(_key, _newColor.value);
  }

  Color? getColor(Asignatura? asignatura) {
    if(asignatura == null) return null;
    return let(_storage.read('${asignatura.codigo}_${asignatura.tipoHora}'), (dynamic element) => Color(element));
  }

  void setIndicatorIsOpen(bool isOpen) {
    indicatorIsOpen.value = isOpen;
  }

  void setOnUpdate(Function? onUpdate) => _onUpdate = onUpdate;

  void _setRandomColorsByHorario(Horario horario) => horario.horario?.forEach((dia) => dia.forEach((bloque) {
    final _asignatura = bloque.asignatura;
    if (_asignatura == null) {
      return;
    }

    addAsignaturaAndSetColor(bloque.asignatura!);
  }));

  void _onChangeAnyController() {
    setIndicatorIsOpen(true);
    isCenteredInCurrentPeriodAndDay.value = false;
    _onUpdate?.call();
  }

  void _setScrollControllerListeners() {
    blockContentController.addListener(() {
      final xPosition = blockContentController.value.getTranslation().x;
      final yPosition = blockContentController.value.getTranslation().y;
      final currentZoom = blockContentController.value.getMaxScaleOnAxis();

      daysHeaderController.value.setTranslationRaw(xPosition, 0, 0);
      periodHeaderController.value.setTranslationRaw(0, yPosition, 0);

      daysHeaderController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1),);
      periodHeaderController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
      cornerController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));

      zoom.value = currentZoom;
      _onChangeAnyController();
    });

    daysHeaderController.addListener(() {
      final currentZoom = daysHeaderController.value.getMaxScaleOnAxis();
      final xPosition = daysHeaderController.value.getTranslation().x;
      final contentYPosition = blockContentController.value.getTranslation().y;

      blockContentController.value.setTranslationRaw(xPosition, contentYPosition, 0);

      blockContentController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
      periodHeaderController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
      cornerController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));

      zoom.value = currentZoom;
      _onChangeAnyController();
    });

    periodHeaderController.addListener(() {
      final yPosition = periodHeaderController.value.getTranslation().y;
      final currentZoom = periodHeaderController.value.getMaxScaleOnAxis();

      final contentXPosition = blockContentController.value.getTranslation().x;

      periodHeaderController.value.setTranslationRaw(0, yPosition, 0);

      blockContentController.value.setTranslationRaw(contentXPosition, yPosition, 0);

      blockContentController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
      daysHeaderController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
      cornerController.value.setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));

      zoom.value = currentZoom;
      _onChangeAnyController();
    });
  }

}