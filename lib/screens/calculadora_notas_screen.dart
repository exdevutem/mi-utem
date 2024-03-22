import 'package:flutter/material.dart';
import 'package:mi_utem/models/evaluacion/evaluacion.dart';
import 'package:mi_utem/services_new/interfaces/controllers/calculator_controller.dart';
import 'package:mi_utem/widgets/calculadora_notas/display_notas_widget.dart';
import 'package:mi_utem/widgets/calculadora_notas/editar_notas_widget.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:watch_it/watch_it.dart';

class CalculadoraNotasScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
  const CalculadoraNotasScreen({super.key});

  @override
  State<CalculadoraNotasScreen> createState() => _CalculadoraNotasScreenState();
}

class _CalculadoraNotasScreenState extends State<CalculadoraNotasScreen> {

  final _controller = di.get<CalculatorController>();

  @override
  void initState() {
    _controller.makeEditable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final partialGrades = watchValue((CalculatorController controller) => controller.partialGrades);
    final gradeTextFieldControllers = watchValue((CalculatorController controller) => controller.gradeTextFieldControllers);
    final percentageTextFieldControllers = watchValue((CalculatorController controller) => controller.percentageTextFieldControllers);

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("Calculadora de notas"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          DisplayNotasWidget(),
          EditarNotasWidget(
            partialGrades: partialGrades,
            gradeTextFieldControllers: gradeTextFieldControllers,
            percentageTextFieldControllers: percentageTextFieldControllers,
            onAddGrade: () => _controller.addGrade(IEvaluacion(
              nota: null,
              porcentaje: null,
            )),
            onRemoveGrade: (idx) => _controller.removeGradeAt(idx),
          )
        ],
      ),
    );
  }
}

