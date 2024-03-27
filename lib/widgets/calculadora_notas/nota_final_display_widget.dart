import 'package:flutter/material.dart';
import 'package:mi_utem/services_new/interfaces/controllers/calculator_controller.dart';
import 'package:watch_it/watch_it.dart';

class NotaFinalDisplayWidget extends StatelessWidget with WatchItMixin {

  const NotaFinalDisplayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final calculatedFinalGrade = watchValue((CalculatorController controller) => controller.calculatedFinalGrade);

    return Column(
      children: [
        Text(calculatedFinalGrade?.toStringAsFixed(1) ?? "--",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
