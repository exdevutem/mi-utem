import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/interfaces/calculator_controller.dart';

class NotaFinalDisplayWidget extends StatelessWidget {

  const NotaFinalDisplayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CalculatorController _calculatorController = Get.find<CalculatorController>();

    return Column(
      children: [
        Obx(() => Text(_calculatorController.calculatedFinalGrade.value?.toStringAsFixed(1) ?? "--",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        )),
      ],
    );
  }
}
