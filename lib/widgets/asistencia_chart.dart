import 'dart:math';

import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/themes/theme.dart';

extension StringExtension on Color {
  toHex() => '#${this.value.toRadixString(16).substring(2, 8)}';
}

class AsistenciaChart extends StatelessWidget {
  final Asistencia? asistencia;

  AsistenciaChart({this.asistencia});

  List<charts.Series<GaugeSegment, String>> _procesarDatos() {
    final data = [
      new GaugeSegment('Asistido', asistencia!.asistidos as int,
          charts.Color.fromHex(code: MainTheme.aprobadoColor.toHex())),
      //new GaugeSegment('No asistido', asistencia.noAsistidos, charts.Color.fromHex(code: MainTheme.reprobadoColor.toHex())),
      new GaugeSegment('Sin registro', asistencia!.sinRegistro as int,
          charts.Color.fromHex(code: MainTheme.disabledColor!.toHex())),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Asistencia',
        domainFn: (datum, index) => datum.segment,
        measureFn: (datum, index) => datum.size,
        colorFn: (datum, index) => datum.color,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.6,
            child: SizedBox(
              height: 200,
              width: 200,
              child: charts.PieChart<String>(
                _procesarDatos(),
                defaultInteractions: true,
                animate: true,
                defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 40,
                  startAngle: pi,
                  arcLength: pi,
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: MainTheme.aprobadoColor,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 15,
              width: 15,
            ),
            Container(width: 10),
            Text("Asistidos (${asistencia!.asistidos})"),
          ],
        ),
        Container(height: 5),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                    color: MainTheme.reprobadoColor,
                    borderRadius: BorderRadius.circular(15)),
                height: 15,
                width: 15),
            Container(width: 10),
            Text("No asistidos (${asistencia!.noAsistidos})"),
          ],
        ),
        Container(height: 5),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                    color: MainTheme.disabledColor,
                    borderRadius: BorderRadius.circular(15)),
                height: 15,
                width: 15),
            Container(width: 10),
            Text("Sin registro (${asistencia!.sinRegistro})"),
          ],
        ),
      ],
    );
  }
}

class GaugeSegment {
  final String segment;
  final int size;
  final charts.Color color;

  GaugeSegment(this.segment, this.size, this.color);
}
