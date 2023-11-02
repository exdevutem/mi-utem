  import 'package:flutter/material.dart';
  import 'package:get/get_state_manager/get_state_manager.dart';
  import 'package:mi_utem/controllers/asignatura/asignatura_controller.dart';
  import 'package:mi_utem/models/evaluacion.dart';
  import 'package:mi_utem/widgets/asignatura/notas_tab/notas_display.dart';
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
        child: controller.obx((asignatura) => ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(10),
              children: <Widget>[
                NotasDisplayWidget(
                  notaFinal: asignatura?.grades?.notaFinal,
                  notaExamen: asignatura?.grades?.notaExamen,
                  notaPresentacion: asignatura?.grades?.notaPresentacion,
                  estado: asignatura?.estado,
                  colorPorEstado: asignatura?.colorPorEstado,
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: asignatura?.grades?.notasParciales.isNotEmpty == true
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, i) {
                              REvaluacion evaluacion = asignatura!.grades!.notasParciales[i];
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
            ),
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
