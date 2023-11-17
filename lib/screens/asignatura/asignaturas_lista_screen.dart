import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/config/routes.dart';
import 'package:mi_utem/controllers/asignatura/asignaturas_controller.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/widgets/asignatura/lista/lista_asignaturas.dart';
import 'package:mi_utem/widgets/asignatura/lista/sin_asignaturas_mensaje.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
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
                  onPressed: () => Get.toNamed(Routes.calculadoraNotas),
                ),
              ]
            : [],
      ),
      body: PullToRefresh(
        onRefresh: () async => await _onRefresh(),
        child: controller.obx(
          (asignaturas) => asignaturas == null || asignaturas.isEmpty ? SinAsignaturasMensaje(mensaje: "Parece que no se encontraron asignaturas.", emoji: "🤔") : ListaAsignaturas(asignaturas: asignaturas),
          onError: (error) => SinAsignaturasMensaje(mensaje:  "Ocurrió un error al obtener las asignaturas", emoji: "😢"),
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
