import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/config/routes.dart';
import 'package:mi_utem/controllers/asignatura_controller.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';

class AsignaturasScreen extends GetView<AsignaturaController> {
  AsignaturasScreen({Key? key}) : super(key: key);

  Future<void> _onRefresh() async {
    controller.getAsignaturas();
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
      body: PullToRefresh(
        onRefresh: () async {
          await _onRefresh();
        },
        child: Obx(
          () => controller.isLoading.value
              ? Container(
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
                )
              : controller.asignaturas.isEmpty
                  ? CustomErrorWidget(
                      emoji: "🤔",
                      title: "Parece que no se encontraron asignaturas",
                    )
                  : ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          Divider(height: 5, indent: 20, endIndent: 20),
                      itemBuilder: (BuildContext context, int i) {
                        Asignatura asignatura = controller.asignaturas[i];
                        return ListTile(
                          onTap: () {
                            controller.asignatura.value = asignatura;
                            Get.toNamed(Routes.asignatura);
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
                      itemCount: controller.asignaturas.length,
                    ),
        ),
      ),

      /*FutureBuilder<List<Asignatura>>(
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
                  child: ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        Divider(height: 5, indent: 20, endIndent: 20),
                    itemBuilder: (BuildContext context, int i) {
                      Asignatura asignatura = _asignaturas[i];
                      return ListTile(
                        onTap: () {
                          Get.to(
                            () => AsignaturaScreen(
                              asignatura: asignatura,
                            ),
                            routeName: Routes.asignatura,
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
      ),*/
    );
  }
}
