import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services_new/interfaces/controllers/calculator_controller.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';
import 'package:watch_it/watch_it.dart';

class NotasCalculadoraWidget extends StatelessWidget with WatchItMixin {

  final List<IEvaluacion> partialGrades;
  final List<MaskedTextController> gradeTextFieldControllers;
  final List<MaskedTextController> percentageTextFieldControllers;
  final Function(int) onRemoveGrade;

  const NotasCalculadoraWidget({
    super.key,
    required this.partialGrades,
    required this.gradeTextFieldControllers,
    required this.percentageTextFieldControllers,
    required this.onRemoveGrade,
  });

  @override
  Widget build(BuildContext context) => ListView.separated(
    shrinkWrap: true,
    physics: const ClampingScrollPhysics(),
    separatorBuilder: (context, index) => const SizedBox(height: 10),
    itemBuilder: (context, idx) => NotaListItem(
      evaluacion: IEvaluacion.fromRemote(partialGrades[idx]),
      editable: true,
      gradeController: gradeTextFieldControllers[idx],
      percentageController: percentageTextFieldControllers[idx],
      onChanged: (evaluacion) => di.get<CalculatorController>().updateGradeAt(idx, evaluacion),
      onDelete: () {
        AnalyticsService.logEvent("calculator_delete_grade");
        onRemoveGrade(idx);
      },
    ),
    itemCount: partialGrades.length,
  );
}
