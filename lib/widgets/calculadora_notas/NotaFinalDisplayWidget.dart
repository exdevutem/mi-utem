import 'package:flutter/material.dart';
import 'package:mi_utem/services_new/interfaces/calculator_service.dart';
import 'package:watch_it/watch_it.dart';

class NotaFinalDisplayWidget extends StatelessWidget {

  const NotaFinalDisplayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(di.get<CalculatorService>().getCalculatedFinalGrade?.toStringAsFixed(1) ?? "--",
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      )
    ],
  );
}
