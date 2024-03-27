import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/interfaces/calculator_controller.dart';
import 'package:mi_utem/themes/theme.dart';

class NotaExamenDisplayWidget extends StatelessWidget {

  const NotaExamenDisplayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CalculatorController _calculatorController = Get.find<CalculatorController>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Examen",
          style: TextStyle(fontSize: 16),
        ),
        Container(
          width: 80,
          margin: const EdgeInsets.only(left: 15),
          child: Obx(() => TextField(
            controller: _calculatorController.examGradeTextFieldController.value,
            textAlign: TextAlign.center,
            onChanged: (String value) => _calculatorController.setExamGrade(double.tryParse(value.replaceAll(",", "."))),
            enabled: _calculatorController.canTakeExam.value,
            decoration: InputDecoration(
              hintText: _calculatorController.minimumRequiredExamGrade.value?.toStringAsFixed(1) ?? "--",
              filled: _calculatorController.canTakeExam.value,
              fillColor: Colors.grey.withOpacity(0.2),
              disabledBorder: MainTheme.theme.inputDecorationTheme.border!.copyWith(
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              TextInputFormatter.withFunction((prev, input) {
                final val = input.text;
                if(val.isEmpty) { // Si está vacío, no hacer nada
                  return input;
                }

                final firstDigit = int.tryParse(val[0]);
                if(firstDigit != null && (firstDigit < 1 || firstDigit > 7)) { // Si el primer dígito es menor a 1 o mayor a 7, no hacer nada
                  return prev;
                }

                if(val.length == 1) {
                  return input;
                }

                final secondDigit = int.tryParse(val[1]);
                if(secondDigit != null && ((secondDigit < 0 || secondDigit > 9) || (firstDigit == 7 && secondDigit > 0)) || val.length > 3) { // Si el segundo dígito es menor a 0 o mayor a 9, o si el primer dígito es 7 y el segundo dígito es mayor a 0, no hacer nada
                  return prev;
                }

                return input;
              }),
            ],
          )),
        ),
      ],
    );
  }
}
