import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/services/grades_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';

class AsignaturaNotasTab extends StatefulWidget {
  final Asignatura asignatura;

  AsignaturaNotasTab({
    Key? key,
    required this.asignatura,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AsignaturaNotasTabState();
}

class _AsignaturaNotasTabState extends State<AsignaturaNotasTab> {
  late Future<Asignatura?> _futureAsignatura;
  Asignatura? _asignatura;

  @override
  void initState() {
    super.initState();
    _futureAsignatura = _getNotasByCodigoAsignatura();
  }

  Future<Asignatura?> _getNotasByCodigoAsignatura(
      [bool refresh = false]) async {
    try {
      final asignatura = await GradesService.getGrades(
        widget.asignatura.id!,
        forceRefresh: refresh,
      );

      setState(() {
        _asignatura = asignatura;
      });

      CalculatorController.to.loadGradesFromAsignatura(asignatura);

      return asignatura;
    } catch (e) {
      return null;
    }
  }

  Future<Asignatura?> _onRefresh() async {
    return _getNotasByCodigoAsignatura(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureAsignatura,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting) {
          late Widget content;

          if (snapshot.hasError) {
            content = SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: CustomErrorWidget(
                title: "Ocurrió un error al cargar las notas",
                error: snapshot.error,
              ),
            );
          } else if (snapshot.hasData &&
              (_asignatura?.notasParciales != null &&
                  _asignatura!.notasParciales.length > 0)) {
            final asignatura = snapshot.data as Asignatura;
            final examGradeController = MaskedTextController(
              mask: '0.0',
              text: asignatura.notaExamen?.toStringAsFixed(1) ?? "",
            );
            final presentationGradeController = MaskedTextController(
              mask: '0.0',
              text: asignatura.notaPresentacion?.toStringAsFixed(1) ?? "",
            );

            content = ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(10),
              children: <Widget>[
                Card(
                  child: Row(
                    children: [
                      Container(
                        height: 130,
                        width: 10,
                        color: _asignatura?.colorPorEstado,
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
                                    _asignatura?.notaFinal
                                            ?.toStringAsFixed(1) ??
                                        "S/N",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _asignatura?.estado ?? "---",
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
                        REvaluacion evaluacion = _asignatura!.notasParciales[i];
                        return NotaListItem(
                          evaluacion: IEvaluacion.fromRemote(evaluacion),
                          /* onChanged: (evaluacion) {
                            _controller.chag(evaluacion, nota);
                          } */
                        );
                      },
                      itemCount: _asignatura!.notasParciales.length,
                    ),
                  ),
                ),
              ],
            );
          } else {
            content = SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: CustomErrorWidget(
                    emoji: "🤔",
                    title: "Parece que aún no hay ponderadores",
                    error: snapshot.error,
                  ),
                ),
              ),
            );
          }
          return PullToRefresh(
            onRefresh: () async {
              await _onRefresh();
            },
            child: content,
          );
        } else {
          return Center(
            child: LoadingIndicator(),
          );
        }
      },
    );
  }
}
