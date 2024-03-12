import 'package:flutter/material.dart';
import 'package:mi_utem/services_new/interfaces/calculator_service.dart';
import 'package:mi_utem/widgets/calculadora_notas/DisplayNotasWidget.dart';
import 'package:mi_utem/widgets/calculadora_notas/EditarNotasWidget.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:watch_it/watch_it.dart';

class CalculadoraNotasScreen extends StatelessWidget {

  const CalculadoraNotasScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _calculatorService = di.get<CalculatorService>();

    _calculatorService.makeEditable();

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("Calculadora de notas"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: const [
          DisplayNotasWidget(),
          EditarNotasWidget()
        ],
      ),
    );
  }
}
