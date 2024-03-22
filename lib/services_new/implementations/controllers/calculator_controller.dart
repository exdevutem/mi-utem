import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:listenable_collections/listenable_collections.dart';
import 'package:mi_utem/models/evaluacion/evaluacion.dart';
import 'package:mi_utem/models/evaluacion/grades.dart';
import 'package:mi_utem/services_new/interfaces/controllers/calculator_controller.dart';

class CalculatorControllerImplementation implements CalculatorController {

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
  ListNotifier<IEvaluacion> partialGrades = ListNotifier();

  /* Controlador de texto para los porcentajes con máscara (para autocompletar formato) */
  @override
  ListNotifier<MaskedTextController> percentageTextFieldControllers = ListNotifier();

  /* Controlador de texto para las notas con máscara (para autocompletar formato) */
  @override
  ListNotifier<MaskedTextController> gradeTextFieldControllers = ListNotifier();

  /* Nota del examen */
  @override
  ValueNotifier<double?> examGrade = ValueNotifier(null);

  /* Controlador de texto para la nota del examen con máscara (para autocompletar formato) */
  @override
  ValueNotifier<MaskedTextController> examGradeTextFieldController = ValueNotifier(MaskedTextController(mask: "0.0"));

  @override
  ValueNotifier<bool> freeEditable = ValueNotifier(false);

  @override
  ValueNotifier<double?> calculatedFinalGrade = ValueNotifier(null);

  @override
  ValueNotifier<double?> calculatedPresentationGrade = ValueNotifier(null);

  @override
  ValueNotifier<int> amountOfPartialGradesWithoutGrade = ValueNotifier(0);

  @override
  ValueNotifier<int> amountOfPartialGradesWithoutPercentage = ValueNotifier(0);

  @override
  ValueNotifier<bool> hasMissingPartialGrade = ValueNotifier(false);

  @override
  ValueNotifier<bool> canTakeExam = ValueNotifier(false);

  @override
  ValueNotifier<double?> minimumRequiredExamGrade = ValueNotifier(null);

  @override
  ValueNotifier<double> percentageOfPartialGrades = ValueNotifier(0);

  @override
  ValueNotifier<double> missingPercentage = ValueNotifier(0);

  @override
  ValueNotifier<bool> hasMissingPercentage = ValueNotifier(false);

  @override
  ValueNotifier<double?> suggestedPercentage = ValueNotifier(null);

  @override
  ValueNotifier<double?> suggestedPresentationGrade = ValueNotifier(null);

  @override
  ValueNotifier<double> percentageWithoutGrade = ValueNotifier(0);

  @override
  ValueNotifier<bool> hasCorrectPercentage = ValueNotifier(false);

  @override
  ValueNotifier<double?> suggestedGrade = ValueNotifier(null);

  @override
  void updateWithGrades(Grades grades) {
    partialGrades.clear();
    percentageTextFieldControllers.clear();
    gradeTextFieldControllers.clear();

    for(final grade in grades.notasParciales) {
      addGrade(IEvaluacion.fromRemote(grade));
    }

    setExamGrade(grades.notaExamen);
    _updateCalculations();
  }

  @override
  void updateGradeAt(int index, IEvaluacion updatedGrade) {
    final grade = partialGrades[index];
    if(!(grade.editable || freeEditable.value)) {
      return;
    }

    partialGrades[index] = updatedGrade;

    _updateCalculations();
    if(hasMissingPartialGrade.value) {
      clearExamGrade();
    }
  }

  @override
  void addGrade(IEvaluacion grade) {
    partialGrades.add(grade);
    percentageTextFieldControllers.add(MaskedTextController(
      mask: "000",
      text: grade.porcentaje?.toStringAsFixed(0) ?? "",
    ));
    gradeTextFieldControllers.add(MaskedTextController(
      mask: "0.0",
      text: grade.nota?.toStringAsFixed(1) ?? "",
    ));
    _updateCalculations();
  }

  @override
  void removeGradeAt(int index) {
    final grade = partialGrades[index];
    if(!(grade.editable || freeEditable.value)) {
      return;
    }

    partialGrades.removeAt(index);
    percentageTextFieldControllers.removeAt(index);
    gradeTextFieldControllers.removeAt(index);
    _updateCalculations();
  }

  @override
  void makeEditable() {
    freeEditable.value = true;
    _updateCalculations();
  }

  @override
  void makeNonEditable() {
    freeEditable.value = false;
    _updateCalculations();
  }

  @override
  void clearExamGrade() {
    examGrade.value = null;
    final examGradeTextFieldController = this.examGradeTextFieldController.value;
    examGradeTextFieldController.updateText("");
    this.examGradeTextFieldController.value = examGradeTextFieldController;
    _updateCalculations();
  }

  @override
  void setExamGrade(num? grade) {
    examGrade.value = grade?.toDouble();
    examGradeTextFieldController.value.updateText(grade?.toDouble().toStringAsFixed(1) ?? "");
    _updateCalculations();
  }

  void _updateCalculations() {
    _calculateFinalGrade();
    _calculatePresentationGrade();
    _calculateAmountOfPartialGradesWithoutGrade();
    _calculateAmountOfPartialGradesWithoutPercentage();
    _checkHasMissingPartialGrade();
    _checkCanTakeExam();
    _calculateMinimumRequiredExamGrade();
    _calculatePercentageOfPartialGrades();
    _calculateMissingPercentage();
    _checkMissingPercentage();
    _calculateSuggestedPercentage();
    _calculateSuggestedPresentationGrade();
    _calculatePercentageWithoutGrade();
    _checkCorrectPercentage();
    _calculateSuggestedGrade();
  }

  void _calculateFinalGrade() {
    _calculatePresentationGrade();
    final calculatedPresentationGrade = this.calculatedPresentationGrade.value;
    if (calculatedPresentationGrade == null) {
      calculatedFinalGrade.value = null;
      return;
    }

    final examGradeValue = examGrade.value;
    if(examGradeValue == null) {
      calculatedFinalGrade.value = calculatedPresentationGrade;
      return;
    }

    final weightedFinalGrade = calculatedPresentationGrade * presentationFinalWeight;
    final weightedExamGrade = examGradeValue * examFinalWeight;

    calculatedFinalGrade.value = weightedFinalGrade + weightedExamGrade;
  }

  void _calculatePresentationGrade() {
    double presentationGrade = 0;
    for (final partialGrade in partialGrades) {
      final weight = (partialGrade.porcentaje ?? 0) / maxPercentage;
      presentationGrade += (partialGrade.nota ?? 0) * weight;
    }

    calculatedPresentationGrade.value = presentationGrade != 0 ? presentationGrade : null;
  }

  void _calculateAmountOfPartialGradesWithoutGrade() => amountOfPartialGradesWithoutGrade.value = partialGrades
      .where((partialGrade) => partialGrade.nota == null)
      .length;

  void _calculateAmountOfPartialGradesWithoutPercentage() => amountOfPartialGradesWithoutPercentage.value = partialGrades
      .where((partialGrade) => partialGrade.porcentaje == null)
      .length;

  void _checkHasMissingPartialGrade() {
    _calculateAmountOfPartialGradesWithoutGrade();
    hasMissingPartialGrade.value = amountOfPartialGradesWithoutGrade.value > 0;
  }

  void _checkCanTakeExam() {
    _checkHasMissingPartialGrade();
    if(hasMissingPartialGrade.value) {
      canTakeExam.value = false;
      return;
    }

    _calculatePresentationGrade();
    final calculatedPresentationGrade = this.calculatedPresentationGrade.value;
    if(calculatedPresentationGrade == null) {
      canTakeExam.value = false;
      return;
    }

    canTakeExam.value = calculatedPresentationGrade >= minimumGradeForExam && calculatedPresentationGrade < passingGrade;
  }

  void _calculateMinimumRequiredExamGrade() {
    _checkCanTakeExam();
    if(!canTakeExam.value) {
      minimumRequiredExamGrade.value = null;
      return;
    }

    _calculatePresentationGrade();
    final calculatedPresentationGrade = this.calculatedPresentationGrade.value;
    if(calculatedPresentationGrade == null) {
      minimumRequiredExamGrade.value = null;
      return;
    }

    final weightedPresentationGrade = calculatedPresentationGrade * presentationFinalWeight;
    minimumRequiredExamGrade.value = (passingGrade - weightedPresentationGrade) / examFinalWeight;
  }

  void _calculatePercentageOfPartialGrades() {
    double percentage = 0;
    for (final partialGrade in partialGrades) {
      percentage += (partialGrade.porcentaje ?? 0);
    }
    percentageOfPartialGrades.value = percentage;
  }

  void _calculateMissingPercentage()  {
    _calculatePercentageOfPartialGrades();
    missingPercentage.value = maxPercentage - percentageOfPartialGrades.value;
  }

  void _checkMissingPercentage() {
    _calculateAmountOfPartialGradesWithoutPercentage();
    hasMissingPercentage.value = amountOfPartialGradesWithoutPercentage.value > 0;
  }

  void _calculateSuggestedPercentage() {
    _calculateAmountOfPartialGradesWithoutPercentage();
    _calculateMissingPercentage();
    final percentage = missingPercentage.value / amountOfPartialGradesWithoutPercentage.value;
    suggestedPercentage.value = 0 <= percentage && percentage <= maxPercentage ? percentage : null;
  }

  void _calculateSuggestedPresentationGrade() {
    _calculateSuggestedPercentage();
    double presentationGrade = 0;
    for(final partialGrade in partialGrades) {
      final weight = (partialGrade.porcentaje ?? (suggestedPercentage.value ?? 0)) / maxPercentage;
      presentationGrade += (partialGrade.nota ?? 0) * weight;
    }

    suggestedPresentationGrade.value =  0 <= presentationGrade && presentationGrade <= maxGrade ? presentationGrade : null;
  }

  void _calculatePercentageWithoutGrade() {
    _calculateSuggestedPercentage();
    double percentage = 0;
    for(final partialGrade in partialGrades) {
      if(partialGrade.nota == null) {
        percentage += (partialGrade.porcentaje ?? (suggestedPercentage.value ?? 0));
      }
    }

    percentageWithoutGrade.value = percentage;
  }

  void _checkCorrectPercentage() {
    _calculatePercentageOfPartialGrades();
    hasCorrectPercentage.value = percentageOfPartialGrades.value == maxPercentage;
  }

  void _calculateSuggestedGrade() {
    _calculatePercentageWithoutGrade();
    final percentageWithoutGrade = this.percentageWithoutGrade.value;
    if(!(hasMissingPartialGrade.value && percentageWithoutGrade > 0)) {
      suggestedGrade.value = null;
      return;
    }

    _calculateSuggestedPresentationGrade();
    final weightOfMissingGrades = percentageWithoutGrade / maxPercentage;
    final requiredGradeValue = passingGrade - (suggestedPresentationGrade.value ?? 0);
    suggestedGrade.value = requiredGradeValue / weightOfMissingGrades;
  }
}