import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';

class NotaFinalDisplayWidget extends StatelessWidget {
  final CalculatorController _calculatorController;

  const NotaFinalDisplayWidget({
    Key? key,
    required CalculatorController calculatorController,
  })  : _calculatorController = calculatorController,
        super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Obx(() =>
              Text(_calculatorController.calculatedFinalGrade?.toStringAsFixed(1) ?? "--",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
          ),
        ],
      );
}
