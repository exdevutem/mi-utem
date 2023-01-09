import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';

import 'package:mi_utem/models/horario.dart';

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
        color: Color(0xFFFFFFFF),
        border: Border(
          right: BorderSide(
            color: Color(0xFFBDBDBD),
            style: BorderStyle.solid,
            width: 1,
          ),
          bottom: BorderSide(
            color: Color(0xFFBDBDBD),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: InkWell(
          child: Container(
            decoration: BoxDecoration(
              color: bloque.codigo != null ? Colors.teal : Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: bloque.asignatura != null
                ? BloqueConInfo(bloque: bloque, colorTexto: colorTexto)
                : DottedBorder(
                    strokeWidth: 2,
                    color: Color(0xFF7F7F7F),
                    borderType: BorderType.RRect,
                    radius: Radius.circular(15),
                    child: Container(),
                  ),
          ),
        ),
      ),
    );
  }
}

class BloqueConInfo extends StatelessWidget {
  const BloqueConInfo({
    Key? key,
    required this.bloque,
    required this.colorTexto,
  }) : super(key: key);

  final BloqueHorario bloque;
  final Color colorTexto;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "${bloque.codigo}",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorTexto,
            fontSize: 18,
          ),
        ),
        Text(
          bloque.asignatura!.toUpperCase(),
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            wordSpacing: 1,
            color: colorTexto,
            fontSize: 18,
          ),
        ),
        Text(
          bloque.sala != null ? bloque.sala! : "Sin sala",
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            color: colorTexto,
            fontSize: 18,
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}
