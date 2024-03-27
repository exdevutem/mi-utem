import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/evaluacion/evaluacion.dart';
import 'package:mi_utem/controllers/interfaces/calculator_controller.dart';
import 'package:mi_utem/widgets/calculadora_notas/display_notas_widget.dart';
import 'package:mi_utem/widgets/calculadora_notas/editar_notas_widget.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';

class CalculadoraNotasScreen extends StatefulWidget {
  const CalculadoraNotasScreen({super.key});

  @override
  State<CalculadoraNotasScreen> createState() => _CalculadoraNotasScreenState();
}

class _CalculadoraNotasScreenState extends State<CalculadoraNotasScreen> {

  CalculatorController _controller = Get.find<CalculatorController>();

  @override
  void initState() {
    _controller.makeEditable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("Calculadora de notas"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          DisplayNotasWidget(),
          Obx(() => EditarNotasWidget(
            partialGrades: _controller.partialGrades,
            gradeTextFieldControllers: _controller.gradeTextFieldControllers,
            percentageTextFieldControllers: _controller.percentageTextFieldControllers,
            onAddGrade: () => _controller.addGrade(IEvaluacion(
              nota: null,
              porcentaje: null,
            )),
            onRemoveGrade: (idx) => _controller.removeGradeAt(idx),
            onChanged: (idx, evaluacion) => _controller.updateGradeAt(idx, evaluacion),
          )),
        ],
      ),
    );
  }
}

