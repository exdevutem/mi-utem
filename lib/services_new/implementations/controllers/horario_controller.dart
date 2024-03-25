import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/asignaturas/asignatura.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/screens/horario/widgets/horario_main_scroller.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/services_new/interfaces/carreras_service.dart';
import 'package:mi_utem/services_new/interfaces/controllers/horario_controller.dart';
import 'package:mi_utem/services_new/interfaces/repositories/horario_repository.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:watch_it/watch_it.dart';

class HorarioControllerImplementation extends ChangeNotifier implements HorarioController {
  final _storage = GetStorage();
  final _randomColors = Colors.primaries.toList()..shuffle();
  final _now = DateTime.now();

  @override
  num daysCount = 6;

  @override
  num periodsCount = 9;

  @override
  String startTime = "7:55";

  @override
  Duration periodDuration = Duration(minutes: 90);

  @override
  Duration periodGap = Duration(minutes: 5);

  @override
  ValueNotifier<Horario?> horario = ValueNotifier(Horario());

  @override
  ValueNotifier<bool> loadingHorario = ValueNotifier(false);

  @override
  List<Color> usedColors = [];

  @override
  ValueNotifier<double> zoom = ValueNotifier(0.5);

  @override
  ValueNotifier<bool> indicatorIsOpen = ValueNotifier(false);

  @override
  ValueNotifier<bool> isCenteredInCurrentPeriodAndDay = ValueNotifier(false);

  @override
  TransformationController blockContentController = TransformationController();

  @override
  TransformationController daysHeaderController = TransformationController();

  @override
  TransformationController periodHeaderController = TransformationController();

  @override
  TransformationController cornerController = TransformationController();

  @override
  List<Color> get unusedColors {
    List<Color> availableColors = [..._randomColors].where((Color color) => !usedColors.contains(color)).toList();
    return availableColors.isEmpty ? [..._randomColors] : availableColors;
  }

  @override
  double get minutesFromStart => _now.difference(DateTime(_now.year, _now.month, _now.day, int.parse(startTime.split(":")[0]), int.parse(startTime.split(":")[1]))).inMinutes.toDouble();

  @override
  int? get indexOfCurrentDayStartingAtMonday => _now.weekday > daysCount ? null : _now.weekday - 1;

  @override
  int? get indexOfCurrentPeriod {
    final periodBlockDuration = periodDuration.inMinutes + (periodGap.inMinutes * 2);

    final minutesModule = minutesFromStart % periodBlockDuration;

    if (minutesModule >= periodGap.inMinutes && minutesModule <= (periodBlockDuration - periodGap.inMinutes)) {
      return (minutesFromStart ~/ periodBlockDuration); // Periodo actual
    }

    return null;
  }

  @override
  void init(BuildContext context) {
    zoom.value = RemoteConfigService.horarioZoom;
    moveViewportToCurrentPeriodAndDay(context);
    setZoom(zoom.value);

    _setScrollControllerListeners();
  }

  @override
  Future<void> getHorarioData({ bool forceRefresh = false }) async {
    loadingHorario.value = true;
    final now = DateTime.now();
    final lastUpdate = _storage.read("last_update_horario") ?? "${now.toIso8601String()}";
    final lastUpdateDate = DateTime.parse(lastUpdate);
    final difference = now.difference(lastUpdateDate).inMinutes;
    if(difference < 15 && forceRefresh == false && horario.value != null && lastUpdate != now.toIso8601String()) {
      loadingHorario.value = false;
      return;
    }


    horario.value = null;

    final carrerasService = di.get<CarrerasService>();
    Carrera? carrera = carrerasService.selectedCarrera.value;
    if (carrera == null) {
      await carrerasService.getCarreras();
    }
    carrera = carrerasService.selectedCarrera.value;

    final carreraId = carrera?.id;
    if(carreraId == null) {
      loadingHorario.value = false;
      return;
    }
    horario.value = await di.get<HorarioRepository>().getHorario(carreraId);
    _setRandomColorsByHorario();

    loadingHorario.value = false;
    _storage.write("last_horario_update", DateTime.now().toIso8601String());
  }

  @override
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

  @override
  void moveViewportToPeriodIndexAndDayIndex(BuildContext context, int periodIndex, int dayIndex) {
    final blockWidth = HorarioMainScroller.blockWidth;
    final x = (dayIndex * blockWidth) + (blockWidth / 2);

    final blockHeight = HorarioMainScroller.blockHeight;
    final y = (periodIndex * blockHeight) + (blockHeight / 2);

    moveViewportTo(context, x, y);
  }

  @override
  void moveViewportToCurrentPeriodAndDay(BuildContext context) {
    final periodIndex = indexOfCurrentPeriod ?? 0;
    final dayIndex = indexOfCurrentDayStartingAtMonday ?? 0;

    moveViewportToPeriodIndexAndDayIndex(context, periodIndex, dayIndex);

    isCenteredInCurrentPeriodAndDay.value = true;
  }

  @override
  void setZoom(double zoom) {
    blockContentController.value = blockContentController.value..setDiagonal(vector.Vector4(zoom, zoom, zoom, 1));
    periodHeaderController.value = periodHeaderController.value..setDiagonal(vector.Vector4(zoom, zoom, zoom, 1));
    daysHeaderController.value = daysHeaderController.value..setDiagonal(vector.Vector4(zoom, zoom, zoom, 1));
    cornerController.value = cornerController.value..setDiagonal(vector.Vector4(zoom, zoom, zoom, 1));

    _onChangeAnyController();
  }

  @override
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

  @override
  Color? getColor(Asignatura asignatura) {
    final _key = '${asignatura.codigo}_${asignatura.tipoHora}';
    final _colorValue = _storage.read(_key);
    return _colorValue != null ? Color(_colorValue) : null;
  }

  @override
  void setIndicatorIsOpen(bool isOpen) {
    indicatorIsOpen.value = isOpen;
  }

  void _setRandomColorsByHorario() {
    final _horario = horario.value?.horario;
    if (_horario == null) {
      return;
    }

    _horario.forEach((dia) => dia.forEach((bloque) {
      final _asignatura = bloque.asignatura;
      if (_asignatura == null) {
        return;
      }

      addAsignaturaAndSetColor(bloque.asignatura!);
    }));
  }

  void _onChangeAnyController() {
    setIndicatorIsOpen(true);
    isCenteredInCurrentPeriodAndDay.value = false;
  }

  void _setScrollControllerListeners() {
    blockContentController.addListener(() {
      final xPosition = blockContentController.value.getTranslation().x;
      final yPosition = blockContentController.value.getTranslation().y;
      final currentZoom = blockContentController.value.getMaxScaleOnAxis();

      daysHeaderController.value = daysHeaderController.value..setTranslationRaw(xPosition, 0, 0);
      periodHeaderController.value = periodHeaderController.value..setTranslationRaw(0, yPosition, 0);

      daysHeaderController.value = daysHeaderController.value..setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1),);
      periodHeaderController.value = periodHeaderController.value..setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
      cornerController.value = cornerController.value..setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));

      zoom.value = currentZoom;
      _onChangeAnyController();
    });

    daysHeaderController.addListener(() {
      final currentZoom = daysHeaderController.value.getMaxScaleOnAxis();
      final xPosition = daysHeaderController.value.getTranslation().x;
      final contentYPosition = blockContentController.value.getTranslation().y;

      blockContentController.value = blockContentController.value..setTranslationRaw(xPosition, contentYPosition, 0);

      blockContentController.value = blockContentController.value..setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
      periodHeaderController.value = periodHeaderController.value..setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
      cornerController.value = cornerController.value..setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));

      zoom.value = currentZoom;
      _onChangeAnyController();
    });

    periodHeaderController.addListener(() {
      final yPosition = periodHeaderController.value.getTranslation().y;
      final currentZoom = periodHeaderController.value.getMaxScaleOnAxis();

      final contentXPosition = blockContentController.value.getTranslation().x;

      periodHeaderController.value = periodHeaderController.value..setTranslationRaw(0, yPosition, 0);

      blockContentController.value = blockContentController.value..setTranslationRaw(contentXPosition, yPosition, 0);

      blockContentController.value = blockContentController.value..setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
      daysHeaderController.value = daysHeaderController.value..setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));
      cornerController.value = cornerController.value..setDiagonal(vector.Vector4(currentZoom, currentZoom, currentZoom, 1));

      zoom.value = currentZoom;
      _onChangeAnyController();
    });
  }

}