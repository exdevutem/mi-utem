import 'package:flutter/material.dart';
import 'package:mi_utem/services_new/interfaces/controllers/calculator_controller.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:watch_it/watch_it.dart';

class NotaExamenDisplayWidget extends StatelessWidget with WatchItMixin{

  const NotaExamenDisplayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _calculatorController = di.get<CalculatorController>();
    final examGradeTextFieldController = watchValue((CalculatorController controller) => controller.examGradeTextFieldController);

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
            controller: examGradeTextFieldController,
            textAlign: TextAlign.center,
            onChanged: (String value) => _calculatorController.setExamGrade(double.tryParse(value.replaceAll(",", "."))),
            enabled: _calculatorController.canTakeExam,
            decoration: InputDecoration(
              hintText: _calculatorController.getMinimumRequiredExamGrade?.toStringAsFixed(1) ?? "",
              filled: !_calculatorController.canTakeExam,
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
