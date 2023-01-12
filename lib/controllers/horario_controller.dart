import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/services/horarios_service.dart';

class HorarioController extends GetxController {
  final GetStorage box = GetStorage();
  final List<Color> randomColors = Colors.primaries.toList()..shuffle();
  final horario = Rxn<Horario>(null);
  final loadingHorario = false.obs;
  final usedColors = <Color>[];

  static HorarioController get to => Get.find();

  @override
  onInit() {
    getHorarioData();
    super.onInit();
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

  List<Color> get unusedColors {
    List<Color> availableColors = [...randomColors];
    availableColors.retainWhere((Color color) => !usedColors.contains(color));
    if (availableColors.length == 0) {
      return [...randomColors];
    }
    return availableColors;
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
    int? colorValue = box.read(key);
    return colorValue != null ? Color(colorValue) : null;
  }

  void _setColor(Asignatura asignatura, Color color) {
    String key = '${asignatura.codigo}_${asignatura.tipoHora}';
    usedColors.add(color);
    box.write(key, color.value);
  }
}
