import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/screens/asignatura/asignatura_estudiantes_tab.dart';
import 'package:mi_utem/screens/asignatura/asignatura_notas_tab.dart';
import 'package:mi_utem/screens/asignatura/asignatura_resumen_tab.dart';
import 'package:mi_utem/screens/calculadora_notas_screen.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/services_new/interfaces/asignaturas_service.dart';
import 'package:mi_utem/services_new/interfaces/calculator_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:watch_it/watch_it.dart';

class _ITabs {
  final String label;
  final Widget child;
  final bool initial;

  _ITabs({
    required this.label,
    required this.child,
    this.initial = false,
  });
}

class AsignaturaDetalleScreen extends StatelessWidget {
  final String? asignaturaId;

  AsignaturaDetalleScreen({
    super.key,
    required this.asignaturaId,
  });

  List<_ITabs> _getTabs(Asignatura asignatura) => [
    _ITabs(
      label: "Resumen",
      child: AsignaturaResumenTab(asignatura: asignatura),
    ),
    _ITabs(
      label: "Notas",
      child: AsignaturaNotasTab(asignaturaId: asignatura.id!),
      initial: true,
    ),
    if (asignatura.estudiantes != null &&
        asignatura.estudiantes!.length > 0)
      _ITabs(
        label: "Estudiantes",
        child: AsignaturaEstudiantesTab(asignatura: asignatura),
      ),
  ];

  bool get _mostrarCalculadora => RemoteConfigService.calculadoraMostrar;

  int _getInitialIndex(Asignatura asignatura) {
    final index = _getTabs(asignatura).indexWhere((tab) => tab.initial);
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    ReviewService.addScreen("AsignaturaScreen");

    return FutureBuilder<Asignatura?>(
      future: di.get<AsignaturasService>().getDetalleAsignatura(asignaturaId),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: CustomAppBar(),
            body: Center(
              child: LoadingIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error is CustomException ? (snapshot.error as CustomException).message : "No sabemos que pasó, pero no pudimos cargar la asignatura.";
          return CustomErrorWidget(
            title: "Ocurrió un error",
            error: error,
          );
        } else if (snapshot.hasData) {
          final asignatura = snapshot.data;
          return DefaultTabController(
            initialIndex: asignatura != null ? _getInitialIndex(asignatura) : 0,
            length: asignatura != null ? _getTabs(asignatura).length : 1,
            child: Scaffold(
              appBar: CustomAppBar(
                title: Text(asignatura?.nombre ?? "Asigntura sin nombre"),
                actions: _mostrarCalculadora ? [
                  IconButton(
                    icon: Icon(Mdi.calculator),
                    tooltip: "Calculadora",
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => CalculadoraNotasScreen()));
                      if (asignatura?.grades != null) {
                        di.get<CalculatorService>().updateWithGrades(asignatura!.grades!);
                      }
                    },
                  ),
                ] : [],
                bottom: asignatura != null ? TabBar(
                  indicatorColor: Colors.white.withOpacity(0.8),
                  tabs: _getTabs(asignatura)
                      .map((tab) => Tab(text: tab.label))
                      .toList(),
                ) : null,
              ),
              body: asignatura != null ? TabBarView(
                children: _getTabs(asignatura).map((tab) => tab.child).toList(),
              ) : Container(),
            ),
          );
        }

        return CustomErrorWidget(
          title: "Ocurrió un error",
          error: "No sabemos que pasó, pero no pudimos cargar la asignatura.",
        );
      }
    );
  }


}
