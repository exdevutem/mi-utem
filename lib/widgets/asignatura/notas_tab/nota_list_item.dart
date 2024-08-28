import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/core/models/evaluacion/evaluacion.dart';
import 'package:mi_utem/core/utils/utils.dart';
import 'package:mi_utem/themes/theme.dart';

class NotaListItem extends StatelessWidget {
  final IEvaluacion evaluacion;

  const NotaListItem({
    super.key,
    required this.evaluacion,
  });

  @override
  Widget build(BuildContext context) => Flex(
    direction: Axis.horizontal,
    mainAxisSize: MainAxisSize.max,
    children: [
      SizedBox(
        width: 90,
        child: Text(evaluacion.descripcion ?? "Nota",
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(width: 16),
      Flexible(
        flex: 3,
        child: Center(
          child: TextField(
            enabled: false,
            controller: MaskedTextController(
              mask: "0.0",
              text: formatoNota(evaluacion.nota) ?? "",
            ),
            decoration: InputDecoration(
              hintText: "--",
              disabledBorder: MainTheme.theme.inputDecorationTheme.border!.copyWith(
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const SizedBox(width: 16),
      Flexible(
        flex: 4,
        child: Center(
          child: TextField(
            controller: MaskedTextController(
              mask: "000",
              text: evaluacion.porcentaje?.toStringAsFixed(0) ?? "",
            ),
            enabled: false,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Peso",
              suffixText: "%",
              disabledBorder: MainTheme.theme.inputDecorationTheme.border!.copyWith(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 20),
    ],
  );
}
