import 'package:flutter/material.dart';
import 'package:mi_utem/models/asignaturas/asignatura.dart';
import 'package:mi_utem/models/evaluacion/evaluacion.dart';
import 'package:mi_utem/widgets/asignatura/notas_tab/notas_display.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';

class AsignaturaNotasTab extends StatelessWidget {
  
  final Asignatura asignatura;
  final Future Function() onRefresh;

  const AsignaturaNotasTab({
    super.key,
    required this.asignatura,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) => PullToRefresh(
    onRefresh: onRefresh,
    child: ListView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(10),
      children: [
        NotasDisplayWidget(
          notaFinal: asignatura.grades?.notaFinal,
          notaExamen: asignatura.grades?.notaExamen,
          notaPresentacion: asignatura.grades?.notaPresentacion,
          estado: asignatura.estado,
          colorPorEstado: asignatura.colorPorEstado,
        ),
        Card(
          child: Container(
            padding: EdgeInsets.all(20),
            child: asignatura.grades?.notasParciales.isNotEmpty == true ? ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, i) {
                REvaluacion evaluacion = asignatura.grades!.notasParciales[i];
                return NotaListItem(evaluacion: IEvaluacion.fromRemote(evaluacion));
              },
              itemCount: asignatura.grades!.notasParciales.length,
            ) : const CustomErrorWidget(
              emoji: "🤔",
              title: "Parece que aún no hay notas ni ponderadores",
            ),
          ),
        ),
      ],
    ),
  );
}

