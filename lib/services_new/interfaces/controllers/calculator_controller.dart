import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:listenable_collections/listenable_collections.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/models/grades.dart';

abstract class CalculatorController {

  /* Notas parciales */
  abstract ListNotifier<IEvaluacion> partialGrades;

  /* Controlador de texto para los porcentajes con máscara (para autocompletar formato) */
  abstract ListNotifier<MaskedTextController> percentageTextFieldControllers;

  /* Controlador de texto para las notas con máscara (para autocompletar formato) */
  abstract ListNotifier<MaskedTextController> gradeTextFieldControllers;

  /* Nota del examen */
  abstract ValueNotifier<double?> examGrade;

  /* Controlador de texto para la nota del examen con máscara (para autocompletar formato) */
  abstract ValueNotifier<MaskedTextController> examGradeTextFieldController;

  abstract ValueNotifier<bool> freeEditable;

  /* Nota final calculada */
  abstract ValueNotifier<double?> calculatedFinalGrade;

  /* Nota de presentación calculada */
  abstract ValueNotifier<double?> calculatedPresentationGrade;

  /* Cantidad de notas parciales sin nota */
  abstract ValueNotifier<int> amountOfPartialGradesWithoutGrade;

  /* Cantidad de notas parciales sin porcentaje */
  abstract ValueNotifier<int> amountOfPartialGradesWithoutPercentage;

  /* Si hay notas parciales sin nota */
  abstract ValueNotifier<bool> hasMissingPartialGrade;

  /* Si puede tomar examen */
  abstract ValueNotifier<bool> canTakeExam;

  /* Nota mínima requerida para el examen */
  abstract ValueNotifier<double?> minimumRequiredExamGrade;

  /* Porcentaje de las notas parciales */
  abstract ValueNotifier<double> percentageOfPartialGrades;

  /* Porcentaje faltante */
  abstract ValueNotifier<double> missingPercentage;

  /* Si hay porcentaje faltante */
  abstract ValueNotifier<bool> hasMissingPercentage;

  /* Porcentaje sugerido */
  abstract ValueNotifier<double?> suggestedPercentage;

  /* Nota de presentación sugerida */
  abstract ValueNotifier<double?> suggestedPresentationGrade;

  /* Porcentaje sin nota */
  abstract ValueNotifier<double> percentageWithoutGrade;

  /* Si hay porcentaje sin nota */
  abstract ValueNotifier<bool> hasCorrectPercentage;

  /* Nota sugerida */
  abstract ValueNotifier<double?> suggestedGrade;

  void updateWithGrades(Grades grades);

  void updateGradeAt(int index, IEvaluacion updatedGrade);

  void clearExamGrade();

  void setExamGrade(num? grade);

  void addGrade(IEvaluacion grade);

  void removeGradeAt(int index);

  void makeEditable();

  void makeNonEditable();
}