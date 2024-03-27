import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/evaluacion/evaluacion.dart';
import 'package:mi_utem/models/evaluacion/grades.dart';

abstract class CalculatorController {

  /* Notas parciales */
  abstract RxList<IEvaluacion> partialGrades;

  /* Controlador de texto para los porcentajes con máscara (para autocompletar formato) */
  abstract RxList<MaskedTextController> percentageTextFieldControllers;

  /* Controlador de texto para las notas con máscara (para autocompletar formato) */
  abstract RxList<MaskedTextController> gradeTextFieldControllers;

  /* Nota del examen */
  abstract Rx<double?> examGrade;

  /* Controlador de texto para la nota del examen con máscara (para autocompletar formato) */
  abstract Rx<MaskedTextController> examGradeTextFieldController;

  abstract RxBool freeEditable;

  /* Nota final calculada */
  abstract Rx<double?> calculatedFinalGrade;

  /* Nota de presentación calculada */
  abstract Rx<double?> calculatedPresentationGrade;

  /* Cantidad de notas parciales sin nota */
  abstract Rx<int> amountOfPartialGradesWithoutGrade;

  /* Cantidad de notas parciales sin porcentaje */
  abstract Rx<int> amountOfPartialGradesWithoutPercentage;

  /* Si hay notas parciales sin nota */
  abstract RxBool hasMissingPartialGrade;

  /* Si puede tomar examen */
  abstract RxBool canTakeExam;

  /* Nota mínima requerida para el examen */
  abstract Rx<double?> minimumRequiredExamGrade;

  /* Porcentaje de las notas parciales */
  abstract RxDouble percentageOfPartialGrades;

  /* Porcentaje faltante */
  abstract RxDouble missingPercentage;

  /* Si hay porcentaje faltante */
  abstract RxBool hasMissingPercentage;

  /* Porcentaje sugerido */
  abstract Rx<double?> suggestedPercentage;

  /* Nota de presentación sugerida */
  abstract Rx<double?> suggestedPresentationGrade;

  /* Porcentaje sin nota */
  abstract RxDouble percentageWithoutGrade;

  /* Si hay porcentaje sin nota */
  abstract RxBool hasCorrectPercentage;

  /* Nota sugerida */
  abstract Rx<double?> suggestedGrade;

  void updateWithGrades(Grades grades);

  void updateGradeAt(int index, IEvaluacion updatedGrade);

  void clearExamGrade();

  void setExamGrade(num? grade);

  void addGrade(IEvaluacion grade);

  void removeGradeAt(int index);

  void makeEditable();

  void makeNonEditable();
}