import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/config/routes.dart';
import 'package:mi_utem/controllers/asignatura_controller.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/screens/asignatura_estudiantes_tab.dart';
import 'package:mi_utem/screens/asignatura_notas_tab.dart';
import 'package:mi_utem/screens/asignatura_resumen_tab.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';

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

class AsignaturaDetalleScreen extends GetView<AsignaturaController> {
  AsignaturaDetalleScreen({Key? key}) : super(key: key);

  String? get tag => Get.parameters['asignaturaId'];

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

  bool get _mostrarCalculadora {
    return RemoteConfigService.calculadoraMostrar;
  }

  int _getInitialIndex(Asignatura asignatura) {
    final index = _getTabs(asignatura).indexWhere((tab) => tab.initial);
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    ReviewService.addScreen("AsignaturaScreen");

    return controller.obx(
      (asignatura) => DefaultTabController(
        initialIndex: asignatura != null ? _getInitialIndex(asignatura) : 0,
        length: asignatura != null ? _getTabs(asignatura).length : 1,
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text(asignatura?.nombre ?? "Asigntura sin nombre"),
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
            bottom: asignatura != null
                ? TabBar(
                    indicatorColor: Colors.white.withOpacity(0.8),
                    tabs: _getTabs(asignatura)
                        .map((tab) => Tab(text: tab.label))
                        .toList(),
                  )
                : null,
          ),
          body: asignatura != null
              ? TabBarView(
                  children:
                      _getTabs(asignatura).map((tab) => tab.child).toList(),
                )
              : Container(),
        ),
      ),
      onLoading: Scaffold(
        appBar: CustomAppBar(),
        body: Center(
          child: LoadingIndicator(),
        ),
      ),
    );
  }
}
