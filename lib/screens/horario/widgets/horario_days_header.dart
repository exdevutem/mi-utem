import 'package:flutter/material.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/bloque_dias_card.dart';

class HorarioDaysHeader extends StatelessWidget {
  final Horario horario;
  final double height;
  final double dayWidth;
  final Color borderColor;
  final double borderWidth;

  const HorarioDaysHeader({
    Key? key,
    required this.horario,
    required this.height,
    required this.dayWidth,
    this.borderColor = MainTheme.dividerColor,
    this.borderWidth = 2,
  });

  List<TableRow> get _children {
    return [
      TableRow(
        children: horario.diasHorario
            .map(
              (day) => BloqueDiasCard(
                day: day!,
                height: height,
                width: dayWidth,
                active: false,
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
        horizontalInside: BorderSide(
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
