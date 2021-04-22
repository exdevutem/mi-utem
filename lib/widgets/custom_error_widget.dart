import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/screens/asignatura_screen.dart';

class CustomErrorWidget extends StatelessWidget {
  final String emoji;
  final String texto;
  final Object error;

  CustomErrorWidget(
      {Key key,
      this.emoji = "😕",
      this.texto = "Ocurrió un error inesperado",
      this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
            ),
          ),
          Container(height: 15),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (error != null)
            Container(height: 15),
          if (error != null)
            Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
