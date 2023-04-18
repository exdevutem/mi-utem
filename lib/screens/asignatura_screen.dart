import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/config/routes.dart';
import 'package:mi_utem/controllers/asignatura_controller.dart';
import 'package:mi_utem/screens/asignatura_estudiantes_tab.dart';
import 'package:mi_utem/screens/asignatura_notas_tab.dart';
import 'package:mi_utem/screens/asignatura_resumen_tab.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';

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

class AsignaturaScreen extends GetView<AsignaturaController> {
  AsignaturaScreen({Key? key}) : super(key: key);

  List<_ITabs> get _tabs => [
        _ITabs(
          label: "Resumen",
          child: AsignaturaResumenTab(asignatura: controller.asignatura.value),
        ),
        _ITabs(
          label: "Notas",
          child: AsignaturaNotasTab(asignatura: controller.asignatura.value!),
          initial: true,
        ),
        if (controller.asignatura.value?.estudiantes != null &&
            controller.asignatura.value!.estudiantes!.length > 0)
          _ITabs(
            label: "Estudiantes",
            child: AsignaturaEstudiantesTab(
                asignatura: controller.asignatura.value),
          ),
      ];

  bool get _mostrarCalculadora {
    return ConfigService.config.getBool(ConfigService.CALCULADORA_MOSTRAR);
  }

  int get _initialIndex {
    final index = _tabs.indexWhere((tab) => tab.initial);
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    ReviewService.addScreen("AsignaturaScreen");

    return DefaultTabController(
      initialIndex: _initialIndex,
      length: _tabs.length,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(
              controller.asignatura.value?.nombre ?? "Asigntura sin nombre"),
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
          bottom: TabBar(
            indicatorColor: Colors.white.withOpacity(0.8),
            tabs: _tabs.map((tab) => Tab(text: tab.label)).toList(),
          ),
        ),
        body: TabBarView(
          children: _tabs.map((tab) => tab.child).toList(),
        ),
      ),
    );
  }
}
