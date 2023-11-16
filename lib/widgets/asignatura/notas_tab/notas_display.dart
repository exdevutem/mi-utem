import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/asignatura/notas_tab/labeled_nota_display.dart';
import 'package:mi_utem/widgets/asignatura/notas_tab/nota_final_display.dart';

class NotasDisplayWidget extends StatefulWidget {
  final num? _notaFinal;
  final num? _notaExamen;
  final num? _notaPresentacion;
  final String? _estado;
  final Color? _colorPorEstado;

  NotasDisplayWidget({
    notaFinal,
    notaExamen,
    notaPresentacion,
    estado,
    colorPorEstado,
  })  : _notaFinal = notaFinal,
        _notaExamen = notaExamen,
        _notaPresentacion = notaPresentacion,
        _estado = estado,
        _colorPorEstado = colorPorEstado;

  @override
  State<StatefulWidget> createState() => NotasDisplayWidgetState();
}

class NotasDisplayWidgetState extends State<NotasDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Container(
            height: 130,
            width: 10,
            color: widget._colorPorEstado,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 20, 20, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  NotaFinalDisplayWidget(
                    notaFinal: widget._notaFinal,
                    estado: widget._estado,
                  ),
                  Container(width: 10),
                  Container(
                    height: 80,
                    width: 0.5,
                    color: Colors.grey,
                  ),
                  Container(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      LabeledNotaDisplayWidget(
                        label: "Examen",
                        nota: widget._notaExamen,
                      ),
                      Container(height: 10),
                      LabeledNotaDisplayWidget(
                          label: "Presentación",
                          nota: widget._notaPresentacion,
                          hint: "--"),
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
}
