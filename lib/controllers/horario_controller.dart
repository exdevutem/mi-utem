import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/horario.dart';

class HorarioController extends GetxController {
  final GetStorage box = GetStorage();
  final List<Color> randomColors = Colors.primaries.toList()..shuffle();
  final asignaturas = <Asignatura>[].obs;

  static HorarioController get to => Get.find();

  @override
  onInit() {
    super.onInit();
  }

  void addAsignaturaAndSetColor(Asignatura asignatura, {Color? color}) {
    bool hasColor = _getColor(asignatura) != null;
    if (!hasColor) {
      Color? newColor = color ?? unusedColors[0];
      asignaturas.add(asignatura);
      _addColorAt(asignaturas.length - 1, newColor);
    } else {
      asignaturas.add(asignatura);
    }
  }

  List<Color> get usedColors {
    return asignaturas
        .map((Asignatura asignatura) => asignatura.colorAsignatura)
        .where((Color? color) => color != null)
        .toList() as List<Color>;
  }

  List<Color> get unusedColors {
    List<Color> availableColors = [...randomColors];
    availableColors.retainWhere((Color color) => !usedColors.contains(color));
    if (availableColors.length == 0) {
      return [...randomColors];
    }
    return availableColors;
  }

  Color? _getColor(Asignatura asignatura) {
    String key = '${asignatura.codigo}_${asignatura.tipoHora}';
    int? colorValue = box.read(key);
    return colorValue != null ? Color(colorValue) : null;
  }

  void _addColorAt(int index, Color color) {
    asignaturas[index].colorAsignatura = color;
    Asignatura asignatura = asignaturas[index];
    String key = '${asignatura.codigo}_${asignatura.tipoHora}';
    box.write(key, color.value);
  }

  void setRandomColorsByHorario(Horario horario) {
    if (horario.asignaturas != null) {
      horario.asignaturas!.map((Asignatura asignatura) {
        addAsignaturaAndSetColor(asignatura);
      });
    }
  }
}
