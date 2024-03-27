import 'package:flutter/material.dart';
import 'package:mi_utem/models/asignaturas/asignatura.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';

class AsignaturaEstudiantesTab extends StatelessWidget {
  final Asignatura? asignatura;

  AsignaturaEstudiantesTab({
    Key? key,
    this.asignatura,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => asignatura == null ? CustomErrorWidget(
    title: "Ocurrió un error trayendo a los estudiantes",
    error: '',
  ) : ListView.separated(
    itemCount: 0,
    separatorBuilder: (context, index) => Divider(
      height: 5,
      indent: 20,
      endIndent: 20,
    ),
    itemBuilder: (context, i) {
      return ListTile(
        onTap: () {
          AnalyticsService.logEvent(
            'asignatura_estudiante_tap',
          );
        },
      );
    },
  );
}
