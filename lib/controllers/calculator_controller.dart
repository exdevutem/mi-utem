import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/evaluacion/evaluacion.dart';
import 'package:mi_utem/core/models/evaluacion/grades.dart';

class CalculatorController {
  static const maxPercentage = 100;
  static const maxGrade = 7;
  static const minimumGradeForExam = 2.95;
  static const passingGrade = 3.95;
  static const examFinalWeight = 0.4;
  static const presentationFinalWeight = 1 - examFinalWeight;

  final partialGrades = <IEvaluacion>[].obs;
  final percentageTextFieldControllers = <MaskedTextController>[].obs;
  final gradeTextFieldControllers = <MaskedTextController>[].obs;
  final examGrade = Rxn<double>();
  final examGradeTextFieldController = MaskedTextController(mask: "0.0");
  final freeEditable = false.obs;

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
    return !hasMissingPartialGrade &&
        calculatedPresentationGrade != null &&
        calculatedPresentationGrade! >= minimumGradeForExam &&
        calculatedPresentationGrade! < passingGrade;
  }

  double? get minimumRequiredExamGrade {
    if (canTakeExam) {
      final weightedPresentationGrade =
          calculatedPresentationGrade! * presentationFinalWeight;
      return (passingGrade - weightedPresentationGrade) / examFinalWeight;
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
    if (hasMissingPartialGrade && percentageWithoutGrade > 0) {
      final weightOfMissingGrades = percentageWithoutGrade / maxPercentage;
      final requiredGradeValue = passingGrade - (suggestedPresentationGrade ?? 0);
      return requiredGradeValue / weightOfMissingGrades;
    }
    return null;
  }

  bool get hasGrades => partialGrades.isNotEmpty;

  void makeEditable() => freeEditable.value = true;

  void makeNonEditable() => freeEditable.value = false;

  void clearGrades() {
    partialGrades.clear();
    percentageTextFieldControllers.clear();
    gradeTextFieldControllers.clear();
    clearExamGrade();
  }

  void updateWithGrades(Grades? grades) {
    partialGrades.clear();
    percentageTextFieldControllers.clear();
    gradeTextFieldControllers.clear();

    if(grades == null) {
      return;
    }

    for(final grade in grades.notasParciales) {
      addGrade(IEvaluacion.fromRemote(grade));
    }

    setExamGrade(grades.notaExamen);
  }

  void updateGradeAt(int index, IEvaluacion updatedGrade) {
    final grade = partialGrades[index];
    if(!(grade.editable || freeEditable.value)) {
      return;
    }

    partialGrades[index] = updatedGrade;

    if (hasMissingPartialGrade) {
      clearExamGrade();
    }
  }

  void clearExamGrade() {
    examGrade.value = null;
    examGradeTextFieldController.text = "";
  }

  void setExamGrade(num? grade, { bool updateTextController = true }) {
    examGrade.value = grade?.toDouble();
    if(updateTextController) {
      examGradeTextFieldController.updateText(grade?.toDouble().toStringAsFixed(1) ?? "");
    }
  }

  void addGrade(IEvaluacion grade) {
    partialGrades.add(grade);
    percentageTextFieldControllers.add(MaskedTextController(mask: "000", text: grade.porcentaje?.toStringAsFixed(0) ?? ""));
    gradeTextFieldControllers.add(MaskedTextController(mask: "0.0", text: grade.nota?.toStringAsFixed(1) ?? ""));
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