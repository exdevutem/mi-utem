import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/models/evaluacion/evaluacion.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';

class NotasCalculadoraWidget extends StatelessWidget {

  final List<IEvaluacion> partialGrades;
  final List<MaskedTextController> gradeTextFieldControllers;
  final List<MaskedTextController> percentageTextFieldControllers;
  final Function(int) onRemoveGrade;
  final Function(int, IEvaluacion) onChanged;

  const NotasCalculadoraWidget({
    super.key,
    required this.partialGrades,
    required this.gradeTextFieldControllers,
    required this.percentageTextFieldControllers,
    required this.onRemoveGrade,
    required this.onChanged,
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
      onChanged: (evaluacion) => onChanged(idx, evaluacion),
      onDelete: () {
        AnalyticsService.logEvent("calculator_delete_grade");
        onRemoveGrade(idx);
      },
    ),
    itemCount: partialGrades.length,
  );
}
