import 'package:flutter/material.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services_new/interfaces/calculator_service.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';
import 'package:watch_it/watch_it.dart';

class NotasCalculadoraWidget extends StatelessWidget {

  const NotasCalculadoraWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final _calculatorService = di.get<CalculatorService>();
    final _partialGrades = watchValue((CalculatorService _service) => _service.partialGrades);
    final _gradeTextFieldControllers = watchValue((CalculatorService _service) => _service.gradeTextFieldControllers);
    final _percentageTextFieldControllers = watchValue((CalculatorService _service) => _service.percentageTextFieldControllers);
   
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, idx) => NotaListItem(
        evaluacion: IEvaluacion.fromRemote(_partialGrades[idx]),
        editable: true,
        gradeController: _gradeTextFieldControllers[idx],
        percentageController: _percentageTextFieldControllers[idx],
        onChanged: (evaluacion) => _calculatorService.updateGradeAt(idx, evaluacion),
        onDelete: () {
          AnalyticsService.logEvent("calculator_delete_grade");
          _calculatorService.removeGradeAt(idx);
        },
      ),
      itemCount: _partialGrades.length,
    );
  }
}
