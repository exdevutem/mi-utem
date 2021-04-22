import 'package:badges/badges.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/screens/usuario_screen.dart';
import 'package:mi_utem/services/asignaturas_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/asistencia_chart.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AsignaturaResumenTab extends StatefulWidget {
  final Asignatura asignatura;

  AsignaturaResumenTab({
    Key key,
    this.asignatura,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AsignaturaResumenTabState();
}

class _AsignaturaResumenTabState extends State<AsignaturaResumenTab> {
  Future<Asignatura> _futureAsignatura;
  Asignatura _asignatura;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().setCurrentScreen(screenName: 'AsignaturaResumenTab');
    _futureAsignatura = _getDetalleAsignatura();
  }

  Future<Asignatura> _getDetalleAsignatura([bool refresh = false]) async {
    Asignatura asignatura = await AsignaturasService
        .getDetalleAsignatura(widget.asignatura.codigo, refresh);

    setState(() {
      _asignatura = asignatura;
    });

    return asignatura;
  }

   Future<void> _onRefresh() async {
    await _getDetalleAsignatura(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureAsignatura,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(
              texto: "Ocurrió un error al obtener el resumen de la asignatura",
              error: snapshot.error
            );
        } else {
          if (snapshot.hasData) {
            return PullToRefresh(
                  onRefresh: () async {
                    await _onRefresh();
                  },
                  child: SingleChildScrollView(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Container(
                    child: ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        Container(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          width: double.infinity,
                          child: Text(
                            "Resumen".toUpperCase(),
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        ListTile(
                          title: Text("Nombre"),
                          subtitle: Text(widget.asignatura.nombre),
                        ),
                        Divider(height: 5, indent: 20, endIndent: 20),
                        ListTile(
                          title: Text("Código"),
                          subtitle: Text(widget.asignatura.codigo),
                        ),
                        if (_asignatura.seccion != null && _asignatura.seccion.isNotEmpty)
                          Divider(height: 5, indent: 20, endIndent: 20),
                        if (_asignatura.seccion != null && _asignatura.seccion.isNotEmpty)
                          ListTile(
                            title: Text("Sección"),
                            subtitle: Text(_asignatura.seccion.toString()),
                          ),
                        Divider(height: 5, indent: 20, endIndent: 20),
                        ListTile(
                          title: Text("Docente"),
                          subtitle: Text(_asignatura.docente),
                          trailing: Badge(
                            shape: BadgeShape.square,
                            borderRadius: BorderRadius.circular(10),
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            elevation: 0,
                            badgeContent: Text(
                              'Nuevo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () async {
                            await Get.to(
                              UsuarioScreen(tipo: 2, query: {"nombre": _asignatura.docente}, asignatura: widget.asignatura),
                            );
                          },
                        ),
                        Divider(height: 5, indent: 20, endIndent: 20),
                        ListTile(
                          title: Text("Tipo de asignatura"),
                          subtitle: Text(_asignatura.tipoAsignatura),
                        ),
                        Divider(height: 5, indent: 20, endIndent: 20),
                        ListTile(
                          title: Text("Tipo de hora"),
                          subtitle: Text(_asignatura.tipoHora),
                        ),
                        Divider(height: 5, indent: 20, endIndent: 20),
                        ListTile(
                          title: Text("Horario"),
                          subtitle: Text(_asignatura.horario),
                        ),
                        Divider(height: 5, indent: 20, endIndent: 20),
                        ListTile(
                          title: Text("Intentos"),
                          subtitle: Text(_asignatura.intentos.toString()),
                        ),
                        Divider(height: 5, indent: 20, endIndent: 20),
                        ListTile(
                          title: Text("Sala"),
                          subtitle: Text(_asignatura.sala),
                        ),
                      ],
                    )
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Text(
                          "Asistencia".toUpperCase(),
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.left,
                        ),
                        ),
                        AsistenciaChart(asistencia: _asignatura.asistencia),
                      ],
                    ),
                  ),
                ),
              ],
            ),),);
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
