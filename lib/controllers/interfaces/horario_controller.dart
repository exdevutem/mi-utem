import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/asignaturas/asignatura.dart';
import 'package:mi_utem/models/horario.dart';

abstract class HorarioController {
  abstract num daysCount;
  abstract num periodsCount;

  abstract String startTime;
  abstract Duration periodDuration;
  abstract Duration periodGap;

  abstract Rx<Horario?> horario;
  abstract RxBool loadingHorario;

  abstract List<Color> usedColors;
  abstract RxDouble zoom;
  abstract RxBool indicatorIsOpen;
  abstract RxBool isCenteredInCurrentPeriodAndDay;

  abstract TransformationController blockContentController;
  abstract TransformationController daysHeaderController;
  abstract TransformationController periodHeaderController;
  abstract TransformationController cornerController;

  List<Color> get unusedColors;

  double get minutesFromStart;

  int? get indexOfCurrentDayStartingAtMonday;

  int? get indexOfCurrentPeriod;

  void init(BuildContext context);

  Future<void> getHorarioData({ bool forceRefresh = false });

  void moveViewportToCurrentPeriodAndDay(BuildContext context);

  void moveViewportToPeriodIndexAndDayIndex(BuildContext context, int periodIndex, int dayIndex);

  void moveViewportTo(BuildContext context, double x, double y);

  void setZoom(double zoom);

  void addAsignaturaAndSetColor(Asignatura asignatura, {Color? color});

  Color? getColor(Asignatura asignatura);

  void setIndicatorIsOpen(bool isOpen);

}