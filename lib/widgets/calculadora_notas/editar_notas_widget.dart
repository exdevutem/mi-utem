import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/interfaces/calculator_controller.dart';
import 'package:mi_utem/models/evaluacion/evaluacion.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/widgets/calculadora_notas/modo_simulacion_widget.dart';
import 'package:mi_utem/widgets/calculadora_notas/notas_calculadora_widget.dart';

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
                onPressed: () {
                  AnalyticsService.logEvent("calculator_add_grade");
                  Get.find<CalculatorController>().addGrade(IEvaluacion(
                    nota: null,
                    porcentaje: null,
                  ));
                },
                child: const Text("Agregar nota"),
              ),
            ],
          ),
        ),
      ],
    ),
  );

}
