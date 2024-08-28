import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/horario_controller.dart';
import 'package:mi_utem/core/models/horario.dart';
import 'package:mi_utem/themes/theme.dart';

class BloqueClase extends StatelessWidget {
  final BloqueHorario block;
  final double width;
  final double height;
  final Color textColor;
  final Color? color;
  final void Function(BloqueHorario)? onTap;
  final void Function(BloqueHorario)? onLongPress;

  const BloqueClase({
    super.key,
    required this.block,
    required this.width,
    required this.height,
    required this.textColor,
    this.color = Colors.teal,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Get.find<HorarioController>().getColor(block.asignatura) ?? this.color,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => onTap?.call(block),
        onLongPress: () => onLongPress?.call(block),
        child: Column(
          children: [
            HorarioText.classCode("${block.codigo}",
              color: textColor,
            ),
            HorarioText.className("${block.asignatura?.nombre.toUpperCase()}",
              color: textColor,
            ),
            HorarioText.classLocation(block.sala ?? "Sin sala",
              color: textColor,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
    ),
  );
}