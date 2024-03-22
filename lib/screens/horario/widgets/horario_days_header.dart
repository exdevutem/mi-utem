import 'package:flutter/material.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/services_new/interfaces/controllers/horario_controller.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/horario/bloque_dias_card.dart';
import 'package:watch_it/watch_it.dart';

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
                active: showActiveDay && entry.key == di.get<HorarioController>().indexOfCurrentDayStartingAtMonday,
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
