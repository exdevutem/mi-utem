import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/models/grades.dart';

abstract class CalculatorService {

  /* Notas parciales */
  ValueNotifier<List<IEvaluacion>> get partialGrades;

  /* Controlador de texto para los porcentajes con máscara (para autocompletar formato) */
  ValueNotifier<List<MaskedTextController>> get percentageTextFieldControllers;

  /* Controlador de texto para las notas con máscara (para autocompletar formato) */
  ValueNotifier<List<MaskedTextController>> get gradeTextFieldControllers;

  /* Nota del examen */
  ValueNotifier<double?> get examGrade;

  /* Controlador de texto para la nota del examen con máscara (para autocompletar formato) */
  MaskedTextController get examGradeTextFieldController;

  ValueNotifier<bool> get freeEditable;

  /* Nota final calculada */
  double? get getCalculatedFinalGrade;

  /* Nota de presentación calculada */
  double? get getCalculatedPresentationGrade;

  /* Cantidad de notas parciales sin nota */
  int get getAmountOfPartialGradesWithoutGrade;

  /* Cantidad de notas parciales sin porcentaje */
  int get getAmountOfPartialGradesWithoutPercentage;

  /* Si hay notas parciales sin nota */
  bool get hasMissingPartialGrade;

  /* Si puede tomar examen */
  bool get canTakeExam;

  /* Nota mínima requerida para el examen */
  double? get getMinimumRequiredExamGrade;

  /* Porcentaje de las notas parciales */
  double get getPercentageOfPartialGrades;

  /* Porcentaje faltante */
  double get getMissingPercentage;

  /* Si hay porcentaje faltante */
  bool get hasMissingPercentage;

  /* Porcentaje sugerido */
  double? get getSuggestedPercentage;

  /* Nota de presentación sugerida */
  double? get getSuggestedPresentationGrade;

  /* Porcentaje sin nota */
  double get getPercentageWithoutGrade;

  /* Si hay porcentaje sin nota */
  bool get hasCorrectPercentage;

  double? get getSuggestedGrade;

  void updateWithGrades(Grades grades);

  void updateGradeAt(int index, IEvaluacion updatedGrade);

  void clearExamGrade();

  void setExamGrade(num? grade);

  void addGrade(IEvaluacion grade);

  void removeGradeAt(int index);

  void makeEditable();

  void makeNonEditable();
}