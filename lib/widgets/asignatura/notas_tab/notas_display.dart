import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/asignatura/notas_tab/labeled_nota_display.dart';
import 'package:mi_utem/widgets/asignatura/notas_tab/nota_final_display.dart';

class NotasDisplayWidget extends StatelessWidget {
  final num? notaFinal;
  final num? notaExamen;
  final num? notaPresentacion;
  final String? estado;
  final Color? colorPorEstado;

  NotasDisplayWidget({
    this.notaFinal,
    this.notaExamen,
    this.notaPresentacion,
    this.estado,
    this.colorPorEstado,
  });

  @override
  @override
  Widget build(BuildContext context) => Card(
    child: Row(
      children: [
        Container(
          height: 130,
          width: 10,
          color: colorPorEstado,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 20, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NotaFinalDisplayWidget(notaFinal: notaFinal, estado: estado),
                SizedBox(width: 10),
                Container(height: 80, width: 0.5, color: Colors.grey),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    LabeledNotaDisplayWidget(
                      label: "Examen",
                      nota: notaExamen,
                      hint: "--",
                    ),
                    Container(height: 10),
                    LabeledNotaDisplayWidget(
                      label: "Presentación",
                      nota: notaPresentacion,
                      hint: "--",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
