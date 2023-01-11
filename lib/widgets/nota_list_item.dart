import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/themes/theme.dart';

class NotaListItem extends StatelessWidget {
  final IEvaluacion evaluacion;
  final TextEditingController? gradeController;
  final TextEditingController? percentageController;
  final Function(IEvaluacion)? onChanged;
  final Function()? onDelete;

  NotaListItem({
    Key? key,
    required this.evaluacion,
    this.gradeController,
    this.percentageController,
    this.onChanged,
    this.onDelete,
  }) : super(key: key);

  final _controller = CalculatorController.to;

  String? get _suggestedGrade {
    return _controller.suggestedGrade?.toStringAsFixed(1);
  }

  String? get _suggestedPercentage {
    return _controller.suggestedPercentage?.toStringAsFixed(0);
  }

  bool get _editable {
    return evaluacion.editable ||
        _controller.freeEditable.value && onChanged != null;
  }

  @override
  Widget build(BuildContext context) {
    final defaultGradeController = MaskedTextController(
      mask: "0.0",
      text: evaluacion.nota?.toStringAsFixed(1) ?? "",
    );
    final defaultPercentageController = MaskedTextController(
      mask: "000",
      text: evaluacion.porcentaje?.toStringAsFixed(0) ?? "",
    );

    return Flex(
      direction: Axis.horizontal,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: 90,
          child: Text(
            evaluacion.descripcion ?? "Nota",
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 16),
        Flexible(
          flex: 3,
          child: Center(
            child: TextField(
              controller: gradeController ?? defaultGradeController,
              enabled: _editable,
              onChanged: (String value) {
                final grade = double.tryParse(
                  value.replaceAll(",", "."),
                );

                final changedGrade = evaluacion.copyWith(nota: grade);
                changedGrade.nota = grade;

                onChanged?.call(changedGrade);

                //_controller.changeGradeAt(widget.index, changedGrade);
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: _suggestedGrade ?? "0.0",
                disabledBorder:
                    MainTheme.theme.inputDecorationTheme.border!.copyWith(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
        ),
        SizedBox(width: 16),
        Flexible(
          flex: 4,
          child: Center(
            child: TextField(
              controller: percentageController ?? defaultPercentageController,
              textAlign: TextAlign.center,
              onChanged: (String value) {
                final percentage = int.tryParse(value);

                final changedGrade =
                    evaluacion.copyWith(porcentaje: percentage);
                changedGrade.porcentaje = percentage;

                onChanged?.call(changedGrade);

                //_controller.changeGradeAt(widget.index, changedGrade);
              },
              enabled: _editable,
              decoration: InputDecoration(
                hintText: _suggestedPercentage ?? "Peso",
                suffixText: "%",
                disabledBorder:
                    MainTheme.theme.inputDecorationTheme.border!.copyWith(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
        ),
        SizedBox(width: 20),
        if (onDelete != null)
          GestureDetector(
            onTap: () {
              onDelete?.call();
              //_controller.removeGradeAt(widget.index);
            },
            child: Icon(
              Icons.delete,
              color: Get.theme.primaryColor,
            ),
          )
      ],
    );
  }
}
