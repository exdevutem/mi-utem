import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/models/evaluacion/evaluacion.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/widgets/calculadora_notas/modo_simulacion_widget.dart';
import 'package:mi_utem/widgets/calculadora_notas/notas_calculadora_widget.dart';
import 'package:watch_it/watch_it.dart';

class EditarNotasWidget extends StatelessWidget with WatchItMixin {
  final List<IEvaluacion> partialGrades;
  final List<MaskedTextController> gradeTextFieldControllers;
  final List<MaskedTextController> percentageTextFieldControllers;
  final Function() onAddGrade;
  final Function(int) onRemoveGrade;

  const EditarNotasWidget({
    super.key,
    required this.partialGrades,
    required this.gradeTextFieldControllers,
    required this.percentageTextFieldControllers,
    required this.onAddGrade,
    required this.onRemoveGrade,
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
              NotasCalculadoraWidget(
                partialGrades: partialGrades,
                gradeTextFieldControllers: gradeTextFieldControllers,
                percentageTextFieldControllers: percentageTextFieldControllers,
                onRemoveGrade: onRemoveGrade,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  AnalyticsService.logEvent("calculator_add_grade");
                  onAddGrade();
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
