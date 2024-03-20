import 'package:flutter/material.dart';
import 'package:mi_utem/services_new/interfaces/controllers/calculator_controller.dart';
import 'package:watch_it/watch_it.dart';

class NotaFinalDisplayWidget extends StatelessWidget {

  const NotaFinalDisplayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(di.get<CalculatorController>().getCalculatedFinalGrade?.toStringAsFixed(1) ?? "--",
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      )
    ],
  );
}
