import 'package:flutter/material.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/widgets/calculadora_notas/ModoSimulacionWidget.dart';
import 'package:mi_utem/widgets/calculadora_notas/NotaExamenDisplayWidget.dart';
import 'package:mi_utem/widgets/calculadora_notas/NotaFinalDisplayWidget.dart';
import 'package:mi_utem/widgets/calculadora_notas/NotaPresentacionDisplayWidget.dart';

class DisplayNotasWidget extends StatelessWidget {
  final CalculatorController _calculatorController;

  const DisplayNotasWidget({
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
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              NotaFinalDisplayWidget(calculatorController: _calculatorController),
              Container(width: 10),
              Container(
                height: 80,
                width: 0.5,
                color: Colors.grey,
              ),
              Container(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  NotaExamenDisplayWidget(calculatorController: _calculatorController),
                  Container(height: 10),
                  NotaPresentacionDisplayWidget(calculatorController: _calculatorController),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
