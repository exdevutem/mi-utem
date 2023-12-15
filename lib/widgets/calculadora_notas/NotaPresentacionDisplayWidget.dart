import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/themes/theme.dart';

class NotaPresentacionDisplayWidget extends StatelessWidget {
  final CalculatorController _calculatorController;

  const NotaPresentacionDisplayWidget({
    Key? key,
    required CalculatorController calculatorController,
  })  : _calculatorController = calculatorController,
        super(key: key);

  @override
  Widget build(BuildContext context) => Obx(
        () => Row(
      children: [
        Text(
          "Pres.",
          style: TextStyle(fontSize: 16),
        ),
        Container(
          width: 80,
          margin: EdgeInsets.only(left: 15),
          child: TextField(
            controller: TextEditingController(text: _calculatorController.calculatedPresentationGrade?.toStringAsFixed(1) ?? ""),
            textAlign: TextAlign.center,
            enabled: false,
            decoration: InputDecoration(
              hintText: "Nota",
              disabledBorder: MainTheme.theme.inputDecorationTheme.border!.copyWith(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            keyboardType:
            TextInputType.numberWithOptions(decimal: true),
          ),
        ),
      ],
    ),
  );
}
