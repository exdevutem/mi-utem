import 'package:flutter/material.dart';
import 'package:mi_utem/services_new/interfaces/calculator_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:watch_it/watch_it.dart';

class NotaExamenDisplayWidget extends StatelessWidget {

  const NotaExamenDisplayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _calculatorService = di.get<CalculatorService>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Examen",
          style: TextStyle(fontSize: 16),
        ),
        Container(
          width: 80,
          margin: const EdgeInsets.only(left: 15),
          child: TextField(
            controller: _calculatorService.examGradeTextFieldController,
            textAlign: TextAlign.center,
            onChanged: (String value) {
              _calculatorService.examGrade.value = double.tryParse(value.replaceAll(",", "."));
            },
            enabled: _calculatorService.canTakeExam,
            decoration: InputDecoration(
              hintText: _calculatorService.getMinimumRequiredExamGrade?.toStringAsFixed(1) ?? "",
              filled: !_calculatorService.canTakeExam,
              fillColor: Colors.grey.withOpacity(0.2),
              disabledBorder: MainTheme.theme.inputDecorationTheme.border!.copyWith(
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
        ),
      ],
    );
  }
}
