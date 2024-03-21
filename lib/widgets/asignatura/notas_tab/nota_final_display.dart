import 'package:flutter/material.dart';

class NotaFinalDisplayWidget extends StatelessWidget {
  final num? notaFinal;
  final String? estado;

  NotaFinalDisplayWidget({
    super.key,
    this.notaFinal,
    this.estado,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
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
