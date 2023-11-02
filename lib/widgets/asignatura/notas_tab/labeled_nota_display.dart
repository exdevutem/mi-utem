  import 'package:flutter/material.dart';
  import 'package:flutter_masked_text/flutter_masked_text.dart';
  import 'package:mi_utem/themes/theme.dart';

  class LabeledNotaDisplayWidget extends StatelessWidget {

    final String label;
    final num? nota;
    final String? hint;

    LabeledNotaDisplayWidget({
      Key? key,
      required this.label,
      this.nota,
      this.hint,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      final notaController = MaskedTextController(
        mask: '0.0',
        text: nota?.toStringAsFixed(1) ?? "",
      );

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(label,
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
                hintText: hint,
                disabledBorder: MainTheme.theme
                    .inputDecorationTheme.border!
                    .copyWith(borderSide: BorderSide(color: Colors.transparent)),
              ),
              keyboardType:
              TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ),
        ],
      );
    }

  }