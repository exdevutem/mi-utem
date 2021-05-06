import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/asignaturas_service.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AsignaturaNotasTab extends StatefulWidget {
  final Asignatura asignatura;
  final Function(Asignatura) onNotas;

  AsignaturaNotasTab({
    Key key,
    this.onNotas,
    @required this.asignatura,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AsignaturaNotasTabState();
}

class _AsignaturaNotasTabState extends State<AsignaturaNotasTab> {
  MaskedTextController _examenController =
      new MaskedTextController(mask: '0.0');
  MaskedTextController _presentacionController =
      new MaskedTextController(mask: '0.0');

  Future<Asignatura> _futureAsignatura;
  Asignatura _asignatura;

  RemoteConfig _remoteConfig;

  @override
  void initState() {
    super.initState();
    _remoteConfig = ConfigService.config;
    FirebaseAnalytics().setCurrentScreen(screenName: 'AsignaturaNotasTab');
    _futureAsignatura = _getNotasByCodigoAsignatura();
  }

  Future<Asignatura> _getNotasByCodigoAsignatura([bool refresh = false]) async {
    Asignatura asignatura = await AsignaturasService
        .getNotasByCodigoAsignatura(widget.asignatura.codigo, refresh);

    setState(() {
      _examenController.text = asignatura.notaExamen?.toStringAsFixed(1) ?? "S/N";
      _presentacionController.text = asignatura.notaPresentacion?.toStringAsFixed(1) ?? "S/N";
      _asignatura = asignatura;
    });

    if (asignatura.evaluaciones.length > 0 && _remoteConfig.getBool(ConfigService.CALCULADORA_MOSTRAR)) {
      widget.onNotas(asignatura);
    }
    
    return asignatura;
  }

  Future<void> _onRefresh() async {
    await _getNotasByCodigoAsignatura(true);
  }

  @override
  Widget build(BuildContext context) {
    //_procesarNotas(prueba);
    return FutureBuilder(
      future: _futureAsignatura,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(
              texto: "Ocurrió un error al cargar las notas",
              error: snapshot.error
            );
        } else {
          if (snapshot.hasData) {
            return PullToRefresh(
                  onRefresh: () async {
                    await _onRefresh();
                  },
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(10),
              children: <Widget>[
                Card(
                  child: Row(
                    children: [
                      Container(height: 130, width: 10, color: _asignatura.colorPorEstado),
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
                              _asignatura.notaFinal?.toStringAsFixed(1) ?? "S/N",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _asignatura.estado,
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
                                    controller: _examenController,
                                    textAlign: TextAlign.center,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      disabledBorder: MainTheme.theme.inputDecorationTheme.border.copyWith(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        )
                                      ),
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
                                      hintText: "--",
                                      disabledBorder: MainTheme.theme.inputDecorationTheme.border.copyWith(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        )
                                      ),
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
                    child: _asignatura.evaluaciones.length > 0 ? ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, i) {
                        Evaluacion evaluacion = _asignatura.evaluaciones[i];
                        return NotaListItem(
                          evaluacion: evaluacion,
                        );
                      },
                      itemCount: _asignatura.evaluaciones.length,
                    ) : CustomErrorWidget(
                emoji: "🤔",
              texto: "Parece que aún no hay ponderadores",
              error: snapshot.error
            )
                  ),
                ),
              ],
            ),);
          } else {
            return Center(
              child: LoadingIndicator(),
            );
          }
        }
      },
    );
  }
}
