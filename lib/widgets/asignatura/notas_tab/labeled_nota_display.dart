import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:mi_utem/themes/theme.dart';

class LabeledNotaDisplayWidget extends StatefulWidget {
  final String _label;
  final num? _nota;
  final String? _hint;

  LabeledNotaDisplayWidget({required String label, num? nota, String? hint})
      : _label = label,
        _nota = nota,
        _hint = hint;

  @override
  _LabeledNotaDisplayWidgetState createState() =>
      _LabeledNotaDisplayWidgetState();
}

class _LabeledNotaDisplayWidgetState extends State<LabeledNotaDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    final notaController = MaskedTextController(
      mask: '0.0',
      text: widget._nota?.toStringAsFixed(1) ?? "",
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          widget._label,
          style: TextStyle(fontSize: 16),
        ),
        Container(
          width: 60,
          margin: EdgeInsets.only(left: 15),
          child: TextField(
            controller: notaController,
            textAlign: TextAlign.center,
            enabled: false,
            decoration: InputDecoration(
              hintText: widget._hint,
              disabledBorder: MainTheme.theme.inputDecorationTheme.border!
                  .copyWith(borderSide: BorderSide(color: Colors.transparent)),
            ),
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
        ),
      ],
    );
  }
}
