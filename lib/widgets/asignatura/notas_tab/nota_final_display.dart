import 'package:flutter/material.dart';

class NotaFinalDisplayWidget extends StatelessWidget {

  final num? notaFinal;
  final String? estado;

  NotaFinalDisplayWidget({
    Key? key,
    this.notaFinal,
    this.estado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(notaFinal?.toStringAsFixed(1) ?? "S/N",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(estado ?? "---",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}