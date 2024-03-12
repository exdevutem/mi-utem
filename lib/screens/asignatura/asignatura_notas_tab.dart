import 'package:flutter/material.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/services_new/interfaces/asignaturas_service.dart';
import 'package:mi_utem/widgets/asignatura/notas_tab/notas_display.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';
import 'package:watch_it/watch_it.dart';

class AsignaturaNotasTab extends StatefulWidget {
  final String asignaturaId;

  const AsignaturaNotasTab({
    super.key,
    required this.asignaturaId,
  });

  @override
  State<AsignaturaNotasTab> createState() => _AsignaturaNotasTabState();
}

class _AsignaturaNotasTabState extends State<AsignaturaNotasTab> {

  Future<Asignatura?> _future = Future.value(null);

  @override
  void initState() {
    _future = di.get<AsignaturasService>().getDetalleAsignatura(widget.asignaturaId, forceRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => PullToRefresh(
    onRefresh: () async {
      setState(() {
        _future = di.get<AsignaturasService>().getDetalleAsignatura(widget.asignaturaId, forceRefresh: true);
      });
    },
    child: FutureBuilder<Asignatura?>(
      future: _future,
      builder: (context, snapshot) {
        final asignatura = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        } else if (snapshot.hasError) {
          final error = snapshot.error is CustomException ? (snapshot.error as CustomException).message : "No sabemos que pasó, pero no pudimos cargar tus notas.";
          return CustomErrorWidget(
            title: "Ocurrió un error al cargar las notas",
            error: error,
          );
        } else if (snapshot.hasData) {
          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(10),
            children: [
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
                  child: asignatura?.grades?.notasParciales.isNotEmpty == true ? ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, i) {
                      REvaluacion evaluacion = asignatura!.grades!.notasParciales[i];
                      return NotaListItem(evaluacion: IEvaluacion.fromRemote(evaluacion));
                    },
                    itemCount: asignatura!.grades!.notasParciales.length,
                  ) : CustomErrorWidget(
                    emoji: "🤔",
                    title: "Parece que aún no hay notas ni ponderadores",
                  ),
                ),
              ),
            ],
          );
        }

        return CustomErrorWidget(
          title: "Ocurrió un error al cargar las notas",
          error: '',
        );
      },
    ),
  );
}

