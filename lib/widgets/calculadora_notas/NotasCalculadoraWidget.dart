import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';

class NotasCalculadoraWidget extends StatelessWidget {
  final CalculatorController _calculatorController;
  final Function onDelete;

  const NotasCalculadoraWidget({
    Key? key,
    required CalculatorController calculatorController,
    required this.onDelete,
  })  : _calculatorController = calculatorController,
        super(key: key);


  @override
  Widget build(BuildContext context) => Obx(() => ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemBuilder: (context, i) {
        REvaluacion evaluacion = _calculatorController.partialGrades[i];
        return NotaListItem(
          evaluacion: IEvaluacion.fromRemote(evaluacion),
          editable: true,
          gradeController: _calculatorController.gradeTextFieldControllers[i],
          percentageController: _calculatorController.percentageTextFieldControllers[i],
          onChanged: (evaluacion) {
            _calculatorController.changeGradeAt(i, evaluacion);
          },
          onDelete: () => Function.apply(onDelete, [_calculatorController, i]),
        );
      },
      itemCount: _calculatorController.partialGrades.length,
    ),
  );
}
