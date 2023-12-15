import 'package:flutter/material.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/widgets/calculadora_notas/ModoSimulacionWidget.dart';
import 'package:mi_utem/widgets/calculadora_notas/NotasCalculadoraWidget.dart';

class EditarNotasWidget extends StatelessWidget {
  final CalculatorController _calculatorController;

  const EditarNotasWidget({
    Key? key,
    required CalculatorController calculatorController,
  })  : _calculatorController = calculatorController,
        super(key: key);

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
              NotasCalculadoraWidget(calculatorController: _calculatorController, onDelete: (controller, index) => _deleteGrade(controller, index)),
              SizedBox(height: 16),
              TextButton(
                onPressed: () => _addGrade(_calculatorController),
                child: Text("Agregar nota"),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  void _deleteGrade(CalculatorController controller, int index) {
    AnalyticsService.logEvent("calculator_delete_grade");
    controller.removeGradeAt(index);
  }

  void _addGrade(CalculatorController controller) {
    AnalyticsService.logEvent("calculator_add_grade");
    controller.addGrade(IEvaluacion(
      nota: null,
      porcentaje: null,
    ));
  }
}
