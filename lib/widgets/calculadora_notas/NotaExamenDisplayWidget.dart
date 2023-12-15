import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/themes/theme.dart';

class NotaExamenDisplayWidget extends StatelessWidget {
  final CalculatorController _calculatorController;

  const NotaExamenDisplayWidget({
    Key? key,
    required CalculatorController calculatorController,
  })  : _calculatorController = calculatorController,
        super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text(
        "Examen",
        style: TextStyle(fontSize: 16),
      ),
      Container(
        width: 80,
        margin: EdgeInsets.only(left: 15),
        child: Obx(() => TextField(
            controller: _calculatorController.examGradeTextFieldController,
            textAlign: TextAlign.center,
            onChanged: (String value) {
              _calculatorController.examGrade.value = double.tryParse(value.replaceAll(",", "."));
            },
            enabled: _calculatorController.canTakeExam,
            decoration: InputDecoration(
              hintText: _calculatorController.minimumRequiredExamGrade?.toStringAsFixed(1) ?? "",
              filled: !_calculatorController.canTakeExam,
              fillColor: Colors.grey.withOpacity(0.2),
              disabledBorder: MainTheme.theme.inputDecorationTheme.border!.copyWith(
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
            keyboardType:
            TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
        ),
      ),
    ],
  );
}
