import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/screens/asignatura_screen.dart';
import 'package:mi_utem/screens/calculadora_notas_screen.dart';
import 'package:mi_utem/services/asignaturas_service.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';

class AsignaturasScreen extends StatefulWidget {
  AsignaturasScreen({Key? key}) : super(key: key);

  @override
  _AsignaturasScreenState createState() => _AsignaturasScreenState();
}

class _AsignaturasScreenState extends State<AsignaturasScreen> {
  Future<List<Asignatura>>? _futureAsignaturas;
  late List<Asignatura> _asignaturas;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'AsignaturasScreen');
    _futureAsignaturas = _getAsignaturas();
  }

  Future<List<Asignatura>> _getAsignaturas([bool refresh = false]) async {
    List<Asignatura> asignaturas =
        await AsignaturasService.getAsignaturas(refresh);
    setState(() {
      _asignaturas = asignaturas;
    });
    return asignaturas;
  }

  Future<void> _onRefresh() async {
    await _getAsignaturas(true);
  }

  bool get _mostrarCalculadora {
    return ConfigService.config.getBool(ConfigService.CALCULADORA_MOSTRAR);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Asignaturas"),
        actions: _mostrarCalculadora
            ? [
                IconButton(
                  icon: Icon(Mdi.calculator),
                  tooltip: "Calculadora",
                  onPressed: () {
                    Get.to(
                      () => CalculadoraNotasScreen(),
                    );
                  },
                ),
              ]
            : [],
      ),
      body: FutureBuilder<List<Asignatura>>(
        future: _futureAsignaturas,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(
                texto: "Ocurrió un error al obtener las asignaturas",
                error: snapshot.error);
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.length > 0) {
                return PullToRefresh(
                  onRefresh: () async {
                    await _onRefresh();
                  },
                  child: ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        Divider(height: 5, indent: 20, endIndent: 20),
                    itemBuilder: (BuildContext context, int i) {
                      Asignatura asignatura = _asignaturas[i];
                      return ListTile(
                        onTap: () {
                          Get.to(
                            () => AsignaturaScreen(asignatura: asignatura),
                          );
                        },
                        title: Text(
                          asignatura.nombre ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(asignatura.codigo ?? ""),
                        trailing: Text(asignatura.tipoHora ?? ""),
                      );
                    },
                    itemCount: _asignaturas.length,
                  ),
                );
              } else {
                return CustomErrorWidget(
                  emoji: "🤔",
                  texto: "Parece que no se encontraron asignaturas",
                );
              }
            } else {
              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: LoadingIndicator(),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
