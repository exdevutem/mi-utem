import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/interfaces/horario_controller.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/horario/bloque_dias_card.dart';

class HorarioDaysHeader extends StatelessWidget {
  final Horario horario;
  final double height;
  final double dayWidth;
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final bool showActiveDay;

  const HorarioDaysHeader({
    Key? key,
    required this.horario,
    required this.height,
    required this.dayWidth,
    this.showActiveDay = true,
    this.borderColor = MainTheme.dividerColor,
    this.backgroundColor = MainTheme.lightGrey,
    this.borderWidth = 2,
  });

  List<TableRow> get _children => [
    TableRow(
      children: horario.diasHorario.asMap().entries.map((entry) => BloqueDiasCard(
        day: entry.value,
        height: height,
        width: dayWidth,
        active: showActiveDay && entry.key == Get.find<HorarioController>().indexOfCurrentDayStartingAtMonday,
        backgroundColor: backgroundColor,
      )).toList(),
    ),
  ];

  @override
  Widget build(BuildContext context) => Table(
    defaultColumnWidth: FixedColumnWidth(dayWidth),
    border: TableBorder(
      verticalInside: BorderSide(
        color: borderColor,
        style: BorderStyle.solid,
        width: borderWidth,
      ),
      bottom: BorderSide(
        color: borderColor,
        style: BorderStyle.solid,
        width: borderWidth,
      ),
    ),
    children: _children,
  );
}
