import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/core/models/evaluacion/grades.dart';
import 'package:mi_utem/widgets/calculadora_notas/display_notas_widget.dart';
import 'package:mi_utem/widgets/calculadora_notas/editar_notas_widget.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/loading/loading_dialog.dart';

class CalculadoraNotasScreen extends StatefulWidget {
  final Grades? grades;

  const CalculadoraNotasScreen({
    super.key,
    this.grades,
  });

  @override
  State<CalculadoraNotasScreen> createState() => _CalculadoraNotasScreenState();
}

class _CalculadoraNotasScreenState extends State<CalculadoraNotasScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoadingDialog(context);
      final CalculatorController calculatorController = Get.find<CalculatorController>();
      calculatorController.makeEditable();
      calculatorController.updateWithGrades(widget.grades);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("Calculadora de notas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: "Limpiar notas",
            onPressed: () => Get.find<CalculatorController>().clearGrades(),
          ),
        ],
      ),
      body: SafeArea(child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const DisplayNotasWidget(),
          const EditarNotasWidget(),
        ],
      )),
    );
  }
}

