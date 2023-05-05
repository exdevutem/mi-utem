import 'package:flutter/material.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/asignaturas_service.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';

class AsignaturaEstudiantesTab extends StatefulWidget {
  final Asignatura? asignatura;

  AsignaturaEstudiantesTab({
    Key? key,
    this.asignatura,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AsignaturaEstudiantesTabState();
}

class _AsignaturaEstudiantesTabState extends State<AsignaturaEstudiantesTab> {
  Future<Asignatura>? _futureAsignatura;

  @override
  void initState() {
    super.initState();
    _futureAsignatura = _getDetalleAsignatura();
  }

  Future<Asignatura> _getDetalleAsignatura({bool refresh = false}) async {
    Asignatura asignatura = await AsignaturasService.getDetalleAsignatura(
      widget.asignatura!.codigo,
      forceRefresh: refresh,
    );

    return asignatura;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureAsignatura,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(
            title: "Ocurrió un error trayendo a los estudiantes",
            error: snapshot.error,
          );
        }

        if (!snapshot.hasData) {
          return Center(child: LoadingIndicator());
        }

        return PullToRefresh(
          onRefresh: () async => await _getDetalleAsignatura(refresh: true),
          child: ListView.separated(
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
          ),
        );
      },
    );
  }
}
