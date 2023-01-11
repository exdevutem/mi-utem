import 'dart:developer';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/evaluacion.dart';

class CalculatorController extends GetxController {
  static const maxPercentage = 100;
  static const maxGrade = 7;
  static const minimumGradeForExam = 3;
  static const passingGrade = 3.95;
  static const examFinalWeight = 0.4;
  static const presentationFinalWeight = maxPercentage - examFinalWeight;

  final partialGrades = <IEvaluacion>[].obs;
  final percentageTextFieldControllers = <MaskedTextController>[].obs;
  final gradeTextFieldControllers = <MaskedTextController>[].obs;
  final examGrade = Rxn<double>();
  final freeEditable = false.obs;

  static CalculatorController get to => Get.find();

  double? get calculatedFinalGrade {
    if (calculatedPresentationGrade != null) {
      if (examGrade.value != null) {
        final weightedFinalGrade =
            calculatedPresentationGrade! * presentationFinalWeight;
        final weightedExamGrade = examGrade.value! * examFinalWeight;

        return weightedFinalGrade + weightedExamGrade;
      }
      return calculatedPresentationGrade;
    }
    return null;
  }

  double? get calculatedPresentationGrade {
    double presentationGrade = 0;
    for (var partialGrade in partialGrades) {
      final weight = (partialGrade.porcentaje ?? 0) / maxPercentage;
      presentationGrade += (partialGrade.nota ?? 0) * weight;
    }
    return presentationGrade != 0 ? presentationGrade : null;
  }

  int get numOfPartialGradesWithoutGrade {
    return partialGrades
        .where((partialGrade) => partialGrade.nota == null)
        .length;
  }

  bool get hasMissingPartialGrade {
    return numOfPartialGradesWithoutGrade > 0;
  }

  bool get canTakeExam {
    return calculatedPresentationGrade != null &&
        calculatedPresentationGrade! >= minimumGradeForExam &&
        calculatedFinalGrade! < passingGrade;
  }

  double? get minimumRequiredExamGrade {
    if (examGrade.value == null) {
      if (calculatedPresentationGrade! < passingGrade) {
        final weightedFinalGrade =
            calculatedPresentationGrade! * presentationFinalWeight;
        return (passingGrade - weightedFinalGrade) / examFinalWeight;
      }
    }
    return null;
  }

  double get percentageOfPartialGrades {
    double percentage = 0;
    for (var partialGrade in partialGrades) {
      percentage += (partialGrade.porcentaje ?? 0);
    }
    return percentage;
  }

  double get missingPercentage {
    log("missingPercentage: $maxPercentage - $percentageOfPartialGrades");
    return maxPercentage - percentageOfPartialGrades;
  }

  int get numOfPartialGradesWithoutPercentage {
    return partialGrades
        .where((partialGrade) => partialGrade.porcentaje == null)
        .length;
  }

  bool get hasMissingPercentage {
    return numOfPartialGradesWithoutPercentage > 0;
  }

  double? get suggestedPercentage {
    final percentage = missingPercentage / numOfPartialGradesWithoutPercentage;
    return 0 <= percentage && percentage <= maxPercentage ? percentage : null;
  }

  double? get suggestedPresentationGrade {
    double presentationGrade = 0;
    for (var partialGrade in partialGrades) {
      final weight = (partialGrade.porcentaje ?? (suggestedPercentage ?? 0)) /
          maxPercentage;
      presentationGrade += (partialGrade.nota ?? 0) * weight;
    }
    return 0 <= presentationGrade && presentationGrade <= maxGrade
        ? presentationGrade
        : null;
  }

  double get percentageWithoutGrade {
    double percentage = 0;
    for (var partialGrade in partialGrades) {
      log("percentageWithoutGrade ${partialGrade.nota} ${partialGrade.porcentaje}");
      if (partialGrade.nota == null) {
        percentage += (partialGrade.porcentaje ?? (suggestedPercentage ?? 0));
      }
    }
    return percentage;
  }

  bool get hasCorrectPercentage {
    return percentageOfPartialGrades == maxPercentage;
  }

  double? get suggestedGrade {
    log("minimumMissingPartialGradesValue percentageWithoutGrade $percentageWithoutGrade $maxPercentage");
    if (hasMissingPartialGrade && percentageWithoutGrade > 0) {
      final weightOfMissingGrades = percentageWithoutGrade / maxPercentage;
      final requiredGradeValue =
          passingGrade - (suggestedPresentationGrade ?? 0);
      final missingGradesValue = requiredGradeValue / weightOfMissingGrades;
      return missingGradesValue;
    }
    return null;
  }

  void makeEditable() {
    freeEditable.value = true;
  }

  void makeNonEditable() {
    freeEditable.value = false;
  }

  void loadGradesFromAsignatura(Asignatura asignatura) {
    partialGrades.clear();
    percentageTextFieldControllers.clear();
    gradeTextFieldControllers.clear();

    for (var evaluacion in asignatura.notasParciales) {
      final partialGrade = IEvaluacion.fromRemote(evaluacion);
      addGrade(partialGrade);
    }
  }

  void _printCurrentGrades() {
    log("\n__________________________");
    for (final partialGrade in partialGrades) {
      log("${partialGrade.descripcion} | ${partialGrade.nota?.toStringAsFixed(1)} | ${partialGrade.porcentaje?.toStringAsFixed(0)}%");
    }
    log("__________________________\n");
  }

  void changeGradeAt(int index, IEvaluacion changedGrade) {
    final grade = partialGrades[index];
    if (grade.editable || freeEditable.value) {
      partialGrades[index] = changedGrade;

      _printCurrentGrades();
    } else {
      throw Exception("No se puede editar una nota que está asignada");
    }
  }

  void addGrade(IEvaluacion grade) {
    partialGrades.add(grade);
    percentageTextFieldControllers.add(
      MaskedTextController(
        mask: "000",
        text: grade.porcentaje?.toStringAsFixed(0) ?? "",
      ),
    );
    gradeTextFieldControllers.add(
      MaskedTextController(
        mask: "0.0",
        text: grade.nota?.toStringAsFixed(1) ?? "",
      ),
    );
    _printCurrentGrades();
  }

  void removeGradeAt(int index) {
    final grade = partialGrades[index];
    if (grade.editable || freeEditable.value) {
      partialGrades.removeRange(index, index + 1);
      percentageTextFieldControllers.removeRange(index, index + 1);
      gradeTextFieldControllers.removeRange(index, index + 1);
    } else {
      throw Exception("No se puede eliminar una nota que está asignada");
    }
  }
}
