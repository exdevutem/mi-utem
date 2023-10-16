import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/config/routes.dart';
import 'package:mi_utem/controllers/asignaturas_controller.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';

class AsignaturasListaScreen extends GetView<AsignaturasController> {
  AsignaturasListaScreen({Key? key}) : super(key: key);

  Future<void> _onRefresh() async {
    controller.refreshAsignaturas();
  }

  bool get _mostrarCalculadora {
    return RemoteConfigService.calculadoraMostrar;
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
      body: PullToRefresh(
        onRefresh: () async {
          await _onRefresh();
        },
        child: controller.obx(
          (asignaturas) => asignaturas == null || asignaturas.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: CustomErrorWidget(
                      emoji: "🤔",
                      title: "Parece que no se encontraron asignaturas",
                    ),
                  ),
                )
              : ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int i) {
                    Asignatura asignatura = asignaturas[i];
                    return AsignaturaListTile(asignatura: asignatura);
                  },
                  itemCount: asignaturas.length,
                ),
          onError: (error) => Center(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: CustomErrorWidget(
                emoji: "🤔",
                title: "Ocurrió un error al obtener las asignaturas",
              ),
            ),
          ),
          onLoading: Container(
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
          ),
        ),
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
          onTap: () => Get.toNamed('${Routes.asignatura}/${asignatura.id}'),
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
