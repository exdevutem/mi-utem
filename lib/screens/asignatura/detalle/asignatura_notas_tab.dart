import 'package:flutter/material.dart';
import 'package:mi_utem/core/models/asignaturas/asignatura.dart';
import 'package:mi_utem/core/models/evaluacion/evaluacion.dart';
import 'package:mi_utem/widgets/asignatura/notas_tab/nota_list_item.dart';
import 'package:mi_utem/widgets/asignatura/notas_tab/notas_display.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
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
  Widget build(BuildContext context) {
    final grades = asignatura.grades;
    final notasParciales = asignatura.grades?.notasParciales;
    if(grades == null || notasParciales == null || notasParciales.isEmpty) {
      return const CustomErrorWidget(
        emoji: "🤔",
        title: "Parece que aún no hay notas ni ponderadores",
      );
    }

    return PullToRefresh(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        children: [
          NotasDisplayWidget(
            notaFinal: grades.notaFinal,
            notaExamen: grades.notaExamen,
            notaPresentacion: grades.notaPresentacion,
            estado: asignatura.estado,
            colorPorEstado: asignatura.colorPorEstado,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, i) => NotaListItem(evaluacion: IEvaluacion.fromRemote(notasParciales[i])),
                itemCount: notasParciales.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


