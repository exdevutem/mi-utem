import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/config/routes.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/screens/asignatura_detalle_screen.dart';
import 'package:mi_utem/services/asignaturas_service.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';

class AsignaturasListaScreen extends StatefulWidget {
  AsignaturasListaScreen({Key? key}) : super(key: key);

  @override
  _AsignaturasListaScreenState createState() => _AsignaturasListaScreenState();
}

class _AsignaturasListaScreenState extends State<AsignaturasListaScreen> {
  Future<List<Asignatura>>? _futureAsignaturas;
  late List<Asignatura> _asignaturas;

  @override
  void initState() {
    super.initState();
    _futureAsignaturas = _getAsignaturas();
  }

  Future<List<Asignatura>> _getAsignaturas([bool refresh = false]) async {
    List<Asignatura> asignaturas =
        await AsignaturasService.getAsignaturas(forceRefresh: refresh);
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
                    Get.toNamed(
                      Routes.calculadoraNotas,
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
                title: "Ocurrió un error al obtener las asignaturas",
                error: snapshot.error);
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.length > 0) {
                return PullToRefresh(
                  onRefresh: () async {
                    await _onRefresh();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int i) {
                        Asignatura asignatura = _asignaturas[i];
                        return AsignaturaListTile(asignatura: asignatura);
                      },
                      itemCount: _asignaturas.length,
                    ),
                  ),
                );
              } else {
                return CustomErrorWidget(
                  emoji: "🤔",
                  title: "Parece que no se encontraron asignaturas",
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

class AsignaturaListTile extends StatelessWidget {
  const AsignaturaListTile({
    Key? key,
    required this.asignatura,
  }) : super(key: key);

  final Asignatura asignatura;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = MainTheme.theme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Card(
        child: InkWell(
          onTap: () => Get.to(
            () => AsignaturaDetalleScreen(
              asignatura: asignatura,
            ),
            routeName: Routes.asignatura,
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asignatura.nombre!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.start,
                ),
                Container(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(asignatura.codigo!),
                    Text(asignatura.tipoHora!),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
