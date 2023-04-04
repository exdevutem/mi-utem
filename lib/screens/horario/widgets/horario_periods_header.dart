import 'package:flutter/material.dart';
import 'package:mi_utem/controllers/horario_controller.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/bloque_periodo_card.dart';

class HorarioPeriodsHeader extends StatelessWidget {
  final HorarioController? controller;
  final Horario horario;
  final double periodHeight;
  final double width;
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final bool showActivePeriod;

  const HorarioPeriodsHeader({
    Key? key,
    this.controller,
    required this.horario,
    required this.periodHeight,
    required this.width,
    this.showActivePeriod = true,
    this.backgroundColor = MainTheme.lightGrey,
    this.borderColor = MainTheme.dividerColor,
    this.borderWidth = 2,
  });

  List<TableRow> get _children {
    return horario.horasInicio
        .asMap()
        .entries
        .map(
          (e) => TableRow(
            children: [
              BloquePeriodoCard(
                inicio: horario.horasInicio[e.key],
                intermedio: horario.horasIntermedio[e.key],
                fin: horario.horasTermino[e.key],
                active: showActivePeriod &&
                    controller?.indexOfCurrentPeriod == e.key,
                height: periodHeight,
                width: width,
                backgroundColor: backgroundColor,
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: FixedColumnWidth(width),
      border: TableBorder(
        horizontalInside: BorderSide(
          color: borderColor,
          style: BorderStyle.solid,
          width: borderWidth,
        ),
        right: BorderSide(
          color: borderColor,
          style: BorderStyle.solid,
          width: borderWidth,
        ),
      ),
      children: _children,
    );
  }
}
