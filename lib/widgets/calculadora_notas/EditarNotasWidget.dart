import 'package:flutter/material.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services_new/interfaces/calculator_service.dart';
import 'package:mi_utem/widgets/calculadora_notas/ModoSimulacionWidget.dart';
import 'package:mi_utem/widgets/calculadora_notas/NotasCalculadoraWidget.dart';
import 'package:watch_it/watch_it.dart';

class EditarNotasWidget extends StatelessWidget {
  const EditarNotasWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Card(
    child: Stack(
      alignment: Alignment.center,
      children: [
        ModoSimulacionWidget(),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const NotasCalculadoraWidget(),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _addGrade,
                child: const Text("Agregar nota"),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  void _addGrade() {
    AnalyticsService.logEvent("calculator_add_grade");
    di.get<CalculatorService>().addGrade(IEvaluacion(
      nota: null,
      porcentaje: null,
    ));
  }
}
