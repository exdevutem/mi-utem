import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';

import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/themes/theme.dart';

class BloqueRamoCard extends StatelessWidget {
  final Color colorTexto = Colors.white;
  final double width;
  final double height;
  final BloqueHorario bloque;

  BloqueRamoCard({
    Key? key,
    required this.bloque,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + 20,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: MainTheme.mediumGrey,
            style: BorderStyle.solid,
            width: 1,
          ),
          bottom: BorderSide(
            color: MainTheme.mediumGrey,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: bloque.asignatura == null
            ? BloqueVacio()
            : BloqueOcupado(
                bloque: bloque,
                width: width,
                height: height,
                textColor: colorTexto),
      ),
    );
  }
}

class BloqueVacio extends StatelessWidget {
  const BloqueVacio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MainTheme.lightGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DottedBorder(
        strokeWidth: 2,
        color: MainTheme.grey,
        borderType: BorderType.RRect,
        radius: Radius.circular(15),
        child: Container(),
      ),
    );
  }
}

class BloqueOcupado extends StatelessWidget {
  const BloqueOcupado({
    Key? key,
    required this.bloque,
    required this.width,
    required this.height,
    required this.textColor,
    this.color = Colors.teal,
  }) : super(key: key);

  final BloqueHorario bloque;
  final double width;
  final double height;
  final Color textColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: bloque.asignatura!.colorAsignatura,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: <Widget>[
            HorarioText.classCode(
              bloque.codigo!,
              color: textColor,
            ),
            HorarioText.className(
              bloque.asignatura!.nombre!.toUpperCase(),
              color: textColor,
            ),
            HorarioText.classLocation(
              bloque.sala ?? "Sin sala",
              color: textColor,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
    );
  }
}
