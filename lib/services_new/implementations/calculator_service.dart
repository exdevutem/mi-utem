import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/grades.dart';
import 'package:mi_utem/services_new/interfaces/calculator_service.dart';

class CalculatorServiceImplementation with ChangeNotifier implements CalculatorService {

  /* Porcentaje máximo de todas las notas */
  static const maxPercentage = 100;

  /* Nota máxima */
  static const maxGrade = 7;

  /* Nota mínima para presentarse al examen */
  static const minimumGradeForExam = 2.95;

  /* Nota para pasar el ramo */
  static const passingGrade = 3.95;

  /* Porcentaje de la nota del examen */
  static const examFinalWeight = 0.4;

  /* Porcentaje de la nota de presentación */
  static const presentationFinalWeight = 1 - examFinalWeight;

  /* Notas parciales */
  @override
  ValueNotifier<List<IEvaluacion>> get partialGrades => ValueNotifier<List<IEvaluacion>>([]);

  /* Controlador de texto para los porcentajes con máscara (para autocompletar formato) */
  @override
  ValueNotifier<List<MaskedTextController>> get percentageTextFieldControllers => ValueNotifier<List<MaskedTextController>>([]);

  /* Controlador de texto para las notas con máscara (para autocompletar formato) */
  @override
  ValueNotifier<List<MaskedTextController>> get gradeTextFieldControllers => ValueNotifier<List<MaskedTextController>>([]);

  /* Nota del examen */
  @override
  ValueNotifier<double?> get examGrade => ValueNotifier<double?>(null);

  /* Controlador de texto para la nota del examen con máscara (para autocompletar formato) */
  @override
  MaskedTextController get examGradeTextFieldController => MaskedTextController(mask: "0.0");

  @override
  ValueNotifier<bool> get freeEditable => ValueNotifier<bool>(false);

  @override
  double? get getCalculatedFinalGrade {
    final calculatedPresentationGrade = getCalculatedPresentationGrade;
    if (calculatedPresentationGrade == null) {
      return null;
    }

    final examGradeValue = examGrade.value;
    if(examGradeValue == null) {
      return calculatedPresentationGrade;
    }

    final weightedFinalGrade = calculatedPresentationGrade * presentationFinalWeight;
    final weightedExamGrade = examGradeValue * examFinalWeight;

    return weightedFinalGrade + weightedExamGrade;
  }

  @override
  double? get getCalculatedPresentationGrade {
    double presentationGrade = 0;
    for (final partialGrade in partialGrades.value) {
      final weight = (partialGrade.porcentaje ?? 0) / maxPercentage;
      presentationGrade += (partialGrade.nota ?? 0) * weight;
    }

    return presentationGrade != 0 ? presentationGrade : null;
  }

  @override
  int get getAmountOfPartialGradesWithoutGrade => partialGrades.value
      .where((partialGrade) => partialGrade.nota == null)
      .length;

  @override
  int get getAmountOfPartialGradesWithoutPercentage => partialGrades.value
      .where((partialGrade) => partialGrade.porcentaje == null)
      .length;

  @override
  bool get hasMissingPartialGrade => getAmountOfPartialGradesWithoutGrade > 0;

  @override
  bool get canTakeExam {
    if(hasMissingPartialGrade) {
      return false;
    }

    final calculatedPresentationGrade = getCalculatedPresentationGrade;
    if(calculatedPresentationGrade == null) {
      return false;
    }

    return calculatedPresentationGrade >= minimumGradeForExam && calculatedPresentationGrade < passingGrade;
  }

  @override
  double? get getMinimumRequiredExamGrade {
    if(!canTakeExam) {
      return null;
    }

    final calculatedPresentationGrade = getCalculatedPresentationGrade;
    if(calculatedPresentationGrade == null) {
      return null;
    }

    final weightedPresentationGrade = calculatedPresentationGrade * presentationFinalWeight;
    return (passingGrade - weightedPresentationGrade) / examFinalWeight;
  }

  @override
  double get getPercentageOfPartialGrades {
    double percentage = 0;
    for (final partialGrade in partialGrades.value) {
      percentage += (partialGrade.porcentaje ?? 0);
    }
    return percentage;
  }

  @override
  double get getMissingPercentage => maxPercentage - getPercentageOfPartialGrades;

  @override
  bool get hasMissingPercentage => getAmountOfPartialGradesWithoutPercentage > 0;

  @override
  double? get getSuggestedPercentage {
    final percentage = getMissingPercentage / getAmountOfPartialGradesWithoutPercentage;
    return 0 <= percentage && percentage <= maxPercentage ? percentage : null;
  }

  @override
  double? get getSuggestedPresentationGrade {
    double presentationGrade = 0;
    for(final partialGrade in partialGrades.value) {
      final weight = (partialGrade.porcentaje ?? (getSuggestedPercentage ?? 0)) / maxPercentage;
      presentationGrade += (partialGrade.nota ?? 0) * weight;
    }

    return 0 <= presentationGrade && presentationGrade <= maxGrade ? presentationGrade : null;
  }

  @override
  double get getPercentageWithoutGrade {
    double percentage = 0;
    for(final partialGrade in partialGrades.value) {
      if(partialGrade.nota == null) {
        percentage += (partialGrade.porcentaje ?? (getSuggestedPercentage ?? 0));
      }
    }

    return percentage;
  }

  @override
  bool get hasCorrectPercentage => getPercentageOfPartialGrades == maxPercentage;

  @override
  double? get getSuggestedGrade {
    final percentageWithoutGrade = getPercentageWithoutGrade;
    if(!(hasMissingPartialGrade && percentageWithoutGrade > 0)) {
      return null;
    }

    final weightOfMissingGrades = percentageWithoutGrade / maxPercentage;
    final requiredGradeValue = passingGrade - (getSuggestedPresentationGrade ?? 0);
    return requiredGradeValue / weightOfMissingGrades;
  }

  @override
  void updateWithGrades(Grades grades) {
    partialGrades.value.clear();
    percentageTextFieldControllers.value.clear();
    gradeTextFieldControllers.value.clear();

    for(final grade in grades.notasParciales) {
      addGrade(IEvaluacion.fromRemote(grade));
    }

    setExamGrade(grades.notaExamen);
    notifyListeners();
  }

  @override
  void updateGradeAt(int index, IEvaluacion updatedGrade) {
    final grade = partialGrades.value[index];
    if(grade.editable || freeEditable.value) {
      partialGrades.value[index] = updatedGrade;

      if(hasMissingPartialGrade) {
        clearExamGrade();
      }
      notifyListeners();
    } else {
      throw CustomException.custom("No se puede editar una nota que está asignada");
    }
  }

  @override
  void addGrade(IEvaluacion grade) {
    partialGrades.value.add(grade);
    percentageTextFieldControllers.value.add(MaskedTextController(
      mask: "000",
      text: grade.porcentaje?.toStringAsFixed(0) ?? "",
    ));
    gradeTextFieldControllers.value.add(MaskedTextController(
      mask: "0.0",
      text: grade.nota?.toStringAsFixed(1) ?? "",
    ));
    notifyListeners();
  }

  @override
  void removeGradeAt(int index) {
    final grade = partialGrades.value[index];
    if(grade.editable || freeEditable.value) {
      partialGrades.value.removeRange(index, index+1);
      percentageTextFieldControllers.value.removeRange(index, index+1);
      gradeTextFieldControllers.value.removeRange(index, index+1);
      notifyListeners();
    } else {
      throw CustomException.custom("No se puede eliminar una nota que está asignada");
    }
  }

  @override
  void makeEditable() => freeEditable.value = true;

  @override
  void makeNonEditable() => freeEditable.value = false;

  @override
  void clearExamGrade() {
    examGrade.value = null;
    examGradeTextFieldController.updateText("");
  }

  @override
  void setExamGrade(num? grade) {
    examGrade.value = grade?.toDouble();
    examGradeTextFieldController.updateText(grade?.toDouble().toStringAsFixed(1) ?? "");
  }
}