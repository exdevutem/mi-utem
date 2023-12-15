import 'package:flutter/material.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/widgets/calculadora_notas/DisplayNotasWidget.dart';
import 'package:mi_utem/widgets/calculadora_notas/EditarNotasWidget.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';

class CalculadoraNotasScreen extends StatelessWidget {
  CalculadoraNotasScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = CalculatorController.to;

    controller.makeEditable();

    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Calculadora de notas"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          DisplayNotasWidget(calculatorController: controller),
          EditarNotasWidget(calculatorController: controller)
        ],
      ),
    );
  }
}
