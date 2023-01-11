import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';

class CalculadoraNotasScreen extends StatelessWidget {
  final Asignatura? asignaturaInicial;

  CalculadoraNotasScreen({
    Key? key,
    this.asignaturaInicial,
  }) : super(key: key);

  final MaskedTextController _examenController =
      new MaskedTextController(mask: '0.0');
  final MaskedTextController _presentacionController =
      new MaskedTextController(mask: '0.0');

  @override
  Widget build(BuildContext context) {
    ReviewService.addScreen("CalculadoraNotasScreen");
    FirebaseAnalytics.instance.setCurrentScreen(
      screenName: 'CalculadoraNotasScreen',
    );

    final controller = CalculatorController.to;

    controller.makeEditable();

    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Calculadora de notas"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Card(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(-20 / 360),
                    child: Text(
                      "Modo simulación".toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Obx(
                            () => Text(
                              controller.calculatedFinalGrade
                                      ?.toStringAsFixed(1) ??
                                  "--",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          /* Text(
                            _asignatura!.estadoCalculado,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ), */
                        ],
                      ),
                      Container(width: 10),
                      Container(
                        height: 80,
                        width: 0.5,
                        color: Colors.grey,
                      ),
                      Container(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Examen",
                                style: TextStyle(fontSize: 16),
                              ),
                              Container(
                                width: 60,
                                margin: EdgeInsets.only(left: 15),
                                child: Obx(
                                  () => TextField(
                                    textAlign: TextAlign.center,
                                    onChanged: (String value) {
                                      controller.examGrade.value =
                                          double.tryParse(
                                        value.replaceAll(",", "."),
                                      );
                                    },
                                    enabled: controller.canTakeExam,
                                    decoration: InputDecoration(
                                      hintText: controller.canTakeExam &&
                                              controller
                                                      .minimumRequiredExamGrade !=
                                                  null
                                          ? "≥${controller.minimumRequiredExamGrade!.toStringAsFixed(1)}"
                                          : "",
                                      filled: !controller.canTakeExam,
                                      fillColor: Colors.grey.withOpacity(0.2),
                                      disabledBorder: MainTheme
                                          .theme.inputDecorationTheme.border!
                                          .copyWith(
                                              borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      )),
                                    ),
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              Text(
                                "Presentacion",
                                style: TextStyle(fontSize: 16),
                              ),
                              Container(
                                width: 60,
                                margin: EdgeInsets.only(left: 15),
                                child: TextField(
                                  controller: _presentacionController,
                                  textAlign: TextAlign.center,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: "Nota",
                                    disabledBorder: MainTheme
                                        .theme.inputDecorationTheme.border!
                                        .copyWith(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(-20 / 360),
                    child: Text(
                      "Modo simulación".toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Obx(
                        () => ListView.separated(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            REvaluacion evaluacion =
                                controller.partialGrades[i];
                            return NotaListItem(
                              evaluacion: IEvaluacion.fromRemote(evaluacion),
                              gradeController:
                                  controller.gradeTextFieldControllers[i],
                              percentageController:
                                  controller.percentageTextFieldControllers[i],
                              onChanged: (evaluacion) {
                                controller.changeGradeAt(i, evaluacion);
                              },
                              onDelete: () {
                                controller.removeGradeAt(i);
                              },
                            );
                          },
                          itemCount: controller.partialGrades.length,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          controller.addGrade(
                            IEvaluacion(
                              nota: null,
                              porcentaje: null,
                            ),
                          );
                        },
                        child: Text("Agregar nota"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
