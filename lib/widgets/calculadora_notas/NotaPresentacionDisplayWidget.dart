import 'package:flutter/material.dart';
import 'package:mi_utem/services_new/interfaces/calculator_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:watch_it/watch_it.dart';

class NotaPresentacionDisplayWidget extends StatelessWidget {
  const NotaPresentacionDisplayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _calculatorService = di.get<CalculatorService>();
    return Row(
      children: [
        const Text("Pres.",
          style: TextStyle(fontSize: 16),
        ),
        Container(
          width: 80,
          margin: const EdgeInsets.only(left: 15),
          child: TextField(
            controller: TextEditingController(text: _calculatorService.getCalculatedPresentationGrade?.toStringAsFixed(1) ?? ""),
            textAlign: TextAlign.center,
            enabled: false,
            decoration: InputDecoration(
              hintText: "Nota",
              disabledBorder: MainTheme.theme.inputDecorationTheme.border!.copyWith(
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
      ],
    );
  }
}
