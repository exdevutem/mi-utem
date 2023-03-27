import 'package:flutter/material.dart';
import 'package:mi_utem/controllers/horario_controller.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/bloque_dias_card.dart';

class HorarioDaysHeader extends StatelessWidget {
  final HorarioController? controller;
  final Horario horario;
  final double height;
  final double dayWidth;
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final bool showActiveDay;

  const HorarioDaysHeader({
    Key? key,
    this.controller,
    required this.horario,
    required this.height,
    required this.dayWidth,
    this.showActiveDay = true,
    this.borderColor = MainTheme.dividerColor,
    this.backgroundColor = MainTheme.lightGrey,
    this.borderWidth = 2,
  });

  List<TableRow> get _children {
    return [
      TableRow(
        children: horario.diasHorario
            .asMap()
            .entries
            .map(
              (entry) => BloqueDiasCard(
                day: entry.value!,
                height: height,
                width: dayWidth,
                active: showActiveDay &&
                    entry.key == controller?.indexOfCurrentDayStartingAtMonday,
                backgroundColor: backgroundColor,
              ),
            )
            .toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Table(
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
}
