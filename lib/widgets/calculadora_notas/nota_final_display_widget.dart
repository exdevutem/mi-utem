import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/core/utils/utils.dart';

class NotaFinalDisplayWidget extends StatelessWidget {

  const NotaFinalDisplayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CalculatorController _calculatorController = Get.find<CalculatorController>();

    return Column(
      children: [
        Obx(() => Text(formatoNota(_calculatorController.calculatedFinalGrade) ?? '--',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        )),
      ],
    );
  }
}
