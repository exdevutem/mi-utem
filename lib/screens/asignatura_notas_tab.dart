import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mi_utem/controllers/asignatura_controller.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';

class AsignaturaNotasTab extends GetView<AsignaturaController> {
  final String asignaturaId;

  AsignaturaNotasTab({
    Key? key,
    required this.asignaturaId,
  }) : super(key: key);

  @override
  String get tag => asignaturaId;

  Future<void> _onRefresh() async {
    controller.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return PullToRefresh(
      onRefresh: _onRefresh,
      child: controller.obx(
        (asignatura) {
          final examGradeController = MaskedTextController(
            mask: '0.0',
            text: asignatura?.grades?.notaExamen?.toStringAsFixed(1) ?? "",
          );
          final presentationGradeController = MaskedTextController(
            mask: '0.0',
            text:
                asignatura?.grades?.notaPresentacion?.toStringAsFixed(1) ?? "",
          );

          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(10),
            children: <Widget>[
              Card(
                child: Row(
                  children: [
                    Container(
                      height: 130,
                      width: 10,
                      color: asignatura?.colorPorEstado,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 20, 20, 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  asignatura?.grades?.notaFinal
                                          ?.toStringAsFixed(1) ??
                                      "S/N",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  asignatura?.estado ?? "---",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                                      child: TextField(
                                        controller: examGradeController,
                                        textAlign: TextAlign.center,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          disabledBorder: MainTheme.theme
                                              .inputDecorationTheme.border!
                                              .copyWith(
                                                  borderSide: BorderSide(
                                            color: Colors.transparent,
                                          )),
                                        ),
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      "Presentación",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Container(
                                      width: 60,
                                      margin: EdgeInsets.only(left: 15),
                                      child: TextField(
                                        controller: presentationGradeController,
                                        textAlign: TextAlign.center,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          hintText: "--",
                                          disabledBorder: MainTheme.theme
                                              .inputDecorationTheme.border!
                                              .copyWith(
                                                  borderSide: BorderSide(
                                            color: Colors.transparent,
                                          )),
                                        ),
                                        keyboardType:
                                            TextInputType.numberWithOptions(
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
                    ),
                  ],
                ),
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: asignatura?.grades?.notasParciales.isNotEmpty == true
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, i) {
                            REvaluacion evaluacion =
                                asignatura!.grades!.notasParciales[i];
                            return NotaListItem(
                              evaluacion: IEvaluacion.fromRemote(evaluacion),
                              /* onChanged: (evaluacion) {
                            _controller.chag(evaluacion, nota);
                          } */
                            );
                          },
                          itemCount: asignatura!.grades!.notasParciales.length,
                        )
                      : CustomErrorWidget(
                          emoji: "🤔",
                          title: "Parece que aún no hay notas ni ponderadores",
                        ),
                ),
              ),
            ],
          );
        },
        onLoading: LoadingIndicator(),
        onError: (error) => SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: CustomErrorWidget(
            title: "Ocurrió un error al cargar las notas",
            error: '',
          ),
        ),
      ),
    );
  }
}
