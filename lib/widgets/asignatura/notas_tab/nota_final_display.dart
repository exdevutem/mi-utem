import 'package:flutter/material.dart';

class NotaFinalDisplayWidget extends StatefulWidget {
  final num? _notaFinal;
  final String? _estado;

  NotaFinalDisplayWidget({Key? key, num? notaFinal, String? estado})
      : _notaFinal = notaFinal,
        _estado = estado,
        super(key: key);

  @override
  _NotaFinalDisplayWidgetState createState() => _NotaFinalDisplayWidgetState();
}

class _NotaFinalDisplayWidgetState extends State<NotaFinalDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          widget._notaFinal?.toStringAsFixed(1) ?? "S/N",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget._estado ?? "---",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
