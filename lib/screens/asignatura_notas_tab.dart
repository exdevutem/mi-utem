import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:mi_utem/controllers/asignatura_controller.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';

class AsignaturaNotasTab extends StatelessWidget {
  final Asignatura? asignatura;

  AsignaturaNotasTab({
    Key? key,
    required this.asignatura,
  }) : super(key: key);

  Future<void> _onRefresh() async {
    if (asignatura?.id != null) {
      AsignaturaController(asignatura!.id!).getAsignaturaDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final examGradeController = MaskedTextController(
      mask: '0.0',
      text: asignatura?.notaExamen?.toStringAsFixed(1) ?? "",
    );
    final presentationGradeController = MaskedTextController(
      mask: '0.0',
      text: asignatura?.notaPresentacion?.toStringAsFixed(1) ?? "",
    );

    return PullToRefresh(
      onRefresh: _onRefresh,
      child: asignatura == null
          ? SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: CustomErrorWidget(
                title: "Ocurrió un error al cargar las notas",
                error: '',
              ),
            )
          : ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(10),
              children: <Widget>[
                Card(
                  child: Row(
                    children: [
                      Container(
                        height: 130,
                        width: 10,
                        color: asignatura!.colorPorEstado,
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
                                    asignatura!.notaFinal?.toStringAsFixed(1) ??
                                        "S/N",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    asignatura!.estado ?? "---",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          controller:
                                              presentationGradeController,
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, i) {
                        REvaluacion evaluacion = asignatura!.notasParciales[i];
                        return NotaListItem(
                          evaluacion: IEvaluacion.fromRemote(evaluacion),
                          /* onChanged: (evaluacion) {
                            _controller.chag(evaluacion, nota);
                          } */
                        );
                      },
                      itemCount: asignatura!.notasParciales.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
