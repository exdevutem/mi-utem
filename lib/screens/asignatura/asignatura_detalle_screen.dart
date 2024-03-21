import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/asignaturas/detalles/navigation_tab.dart';
import 'package:mi_utem/screens/asignatura/asignatura_estudiantes_tab.dart';
import 'package:mi_utem/screens/asignatura/asignatura_notas_tab.dart';
import 'package:mi_utem/screens/asignatura/asignatura_resumen_tab.dart';
import 'package:mi_utem/screens/calculadora_notas_screen.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/services_new/interfaces/controllers/calculator_controller.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:watch_it/watch_it.dart';

class AsignaturaDetalleScreen extends StatelessWidget {
  final Asignatura asignatura;

  AsignaturaDetalleScreen({
    super.key,
    required this.asignatura,
  });

  bool get _mostrarCalculadora => RemoteConfigService.calculadoraMostrar;

  @override
  Widget build(BuildContext context) {
    ReviewService.addScreen("AsignaturaScreen");

    final tabs = [
      NavigationTab(
        label: "Resumen",
        child: AsignaturaResumenTab(asignatura: asignatura),
      ),
      NavigationTab(
        label: "Notas",
        child: AsignaturaNotasTab(asignatura: asignatura),
        initial: true,
      ),
      if ((asignatura.estudiantes?.length ?? 0) > 0) NavigationTab(
        label: "Estudiantes",
        child: AsignaturaEstudiantesTab(asignatura: asignatura),
      ),
    ];
    final index = tabs.indexWhere((tab) => tab.initial);

    return DefaultTabController(
      initialIndex: index == -1 ? 0 : index,
      length: tabs.length,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(asignatura.nombre ?? "Asignatura sin nombre"),
          actions: _mostrarCalculadora ? [
            IconButton(
              icon: Icon(Mdi.calculator),
              tooltip: "Calculadora",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => CalculadoraNotasScreen()));
                final grades = asignatura.grades;
                if (grades != null) {
                  di.get<CalculatorController>().updateWithGrades(grades);
                }
              },
            ),
          ] : [],
          bottom: TabBar(
            indicatorColor: Colors.white.withOpacity(0.8),
            tabs: tabs.map((tab) => Tab(text: tab.label)).toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.map((tab) => tab.child).toList(),
        ),
      ),
    );
  }


}
