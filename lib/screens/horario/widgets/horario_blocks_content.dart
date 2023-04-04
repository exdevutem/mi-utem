import 'package:flutter/material.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/bloque_ramo_card.dart';

class HorarioBlocksContent extends StatelessWidget {
  final Horario horario;
  final double blockHeight;
  final double blockWidth;
  final double blockInternalMargin;
  final Color borderColor;
  final double borderWidth;

  const HorarioBlocksContent({
    Key? key,
    required this.horario,
    required this.blockHeight,
    required this.blockWidth,
    this.blockInternalMargin = 0,
    this.borderColor = MainTheme.dividerColor,
    this.borderWidth = 2,
  });

  List<TableRow> get _children {
    final rows = <TableRow>[];
    for (int blockIndex = 0;
        blockIndex < horario.horarioEnlazado.length;
        blockIndex++) {
      final currentRow = <Widget>[];

      if ((blockIndex % 2) == 0) {
        List<BloqueHorario> bloquePorDias = horario.horarioEnlazado[blockIndex];
        for (num dia = 0; dia < bloquePorDias.length; dia++) {
          BloqueHorario block = horario.horarioEnlazado[blockIndex][dia as int];

          currentRow.add(
            ClassBlockCard(
              block: block,
              height: blockHeight,
              width: blockWidth,
              internalMargin: blockInternalMargin,
            ),
          );
        }
        rows.add(TableRow(children: currentRow));
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: FixedColumnWidth(blockWidth),
      border: TableBorder(
        horizontalInside: BorderSide(
          color: borderColor,
          style: BorderStyle.solid,
          width: borderWidth,
        ),
        verticalInside: BorderSide(
          color: borderColor,
          style: BorderStyle.solid,
          width: borderWidth,
        ),
      ),
      children: _children,
    );
  }
}
