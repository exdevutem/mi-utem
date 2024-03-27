import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/evaluacion/evaluacion.dart';
import 'package:mi_utem/controllers/interfaces/calculator_controller.dart';
import 'package:mi_utem/themes/theme.dart';

class NotaListItem extends StatelessWidget {
  final IEvaluacion evaluacion;
  final bool editable;
  final TextEditingController? gradeController;
  final TextEditingController? percentageController;
  final Function(IEvaluacion)? onChanged;
  final Function()? onDelete;

  const NotaListItem({
    super.key,
    required this.evaluacion,
    this.editable = false,
    this.gradeController,
    this.percentageController,
    this.onChanged,
    this.onDelete,
  });

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

    final showSuggestedGrade = editable;
    CalculatorController calculatorController = Get.find<CalculatorController>();


    return Flex(
      direction: Axis.horizontal,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 90,
          child: Text(evaluacion.descripcion ?? "Nota",
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 16),
        Flexible(
          flex: 3,
          child: Center(
            child: Obx(() => TextField(
              controller: gradeController ?? defaultGradeController,
              enabled: editable,
              onChanged: (String value) {
                final grade = double.tryParse(value.replaceAll(",", "."));

                final changedGrade = evaluacion.copyWith(nota: grade);
                changedGrade.nota = grade;

                onChanged?.call(changedGrade);
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: showSuggestedGrade ? (calculatorController.suggestedGrade.value?.toStringAsFixed(0) ?? "--") : "--",
                disabledBorder: MainTheme.theme.inputDecorationTheme.border!.copyWith(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                TextInputFormatter.withFunction((prev, input) {
                  final val = input.text;
                  if(val.isEmpty) { // Si está vacío, no hacer nada
                    return input;
                  }

                  final firstDigit = int.tryParse(val[0]);
                  if(firstDigit != null && (firstDigit < 1 || firstDigit > 7)) { // Si el primer dígito es menor a 1 o mayor a 7, no hacer nada
                    return prev;
                  }

                  if(val.length == 1) {
                    return input;
                  }

                  final secondDigit = int.tryParse(val[1]);
                  if(secondDigit != null && ((secondDigit < 0 || secondDigit > 9) || (firstDigit == 7 && secondDigit > 0)) || val.length > 3) { // Si el segundo dígito es menor a 0 o mayor a 9, o si el primer dígito es 7 y el segundo dígito es mayor a 0, no hacer nada
                    return prev;
                  }

                  return input;
                }),
              ],
            )),
          ),
        ),
        SizedBox(width: 16),
        Flexible(
          flex: 4,
          child: Center(
            child: Obx(() => TextField(
              controller: percentageController ?? defaultPercentageController,
              textAlign: TextAlign.center,
              onChanged: (String value) {
                final percentage = int.tryParse(value);
                final changedGrade = evaluacion.copyWith(porcentaje: percentage);
                changedGrade.porcentaje = percentage;
                onChanged?.call(changedGrade);
              },
              enabled: editable,
              decoration: InputDecoration(
                hintText: calculatorController.suggestedPercentage.value?.toStringAsFixed(0) ?? "Peso",
                suffixText: "%",
                disabledBorder: MainTheme.theme.inputDecorationTheme.border!.copyWith(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
                // Solo permitir números entre 0 y 100
                TextInputFormatter.withFunction((prev, input) {
                  final val = input.text;
                  if(val.isEmpty) { // Si está vacío, no hacer nada
                    return input;
                  }

                  final number = int.tryParse(val);
                  if(number == null) { // Si no es un número, no hacer nada
                    return prev;
                  }

                  return number > 100 ? prev : input;
                }),

              ],
            )),
          ),
        ),
        SizedBox(width: 20),
        if (onDelete != null)GestureDetector(
          onTap: () => onDelete?.call(),
          child: Icon(
            Icons.delete,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
