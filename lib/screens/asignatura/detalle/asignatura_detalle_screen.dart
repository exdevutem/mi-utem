import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/core/models/asignaturas/asignatura.dart';
import 'package:mi_utem/core/models/asignaturas/detalles/navigation_tab.dart';
import 'package:mi_utem/core/services/grades_service.dart';
import 'package:mi_utem/screens/asignatura/detalle/asignatura_notas_tab.dart';
import 'package:mi_utem/screens/asignatura/detalle/asignatura_resumen_tab.dart';
import 'package:mi_utem/screens/calculadora_notas_screen.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';

class AsignaturaDetalleScreen extends StatefulWidget {
  final Asignatura asignatura;

  const AsignaturaDetalleScreen({
    super.key,
    required this.asignatura,
  });

  @override
  State<AsignaturaDetalleScreen> createState() => _AsignaturaDetalleScreenState(asignatura: asignatura);
}

class _AsignaturaDetalleScreenState extends State<AsignaturaDetalleScreen> {

  Asignatura asignatura;

  _AsignaturaDetalleScreenState({
    required this.asignatura,
  });

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
        child: AsignaturaNotasTab(
          asignatura: asignatura,
          onRefresh: () async {
            final grades = await Get.find<GradesService>().getGrades(this.asignatura, forceRefresh: true);
            logger.d('Refresh ${asignatura.nombre}', [grades]);
            setState(() => this.asignatura = asignatura.copyWith(grades: grades));
          },
        ),
        initial: true,
      ),
    ];

    return DefaultTabController(
      initialIndex: tabs.indexWhere((it) => it.initial),
      length: tabs.length,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(asignatura.nombre),
          actions: RemoteConfigService.calculadoraMostrar ? [
            IconButton(
              icon: Icon(Mdi.calculator),
              tooltip: "Calculadora",
              onPressed: _onTapCalculadora,
            ),
          ] : [],
          bottom: TabBar(
            indicatorColor: Colors.white.withOpacity(0.8),
            tabs: tabs.map((e) => Tab(text: e.label)).toList(),
          ),
        ),
        body: SafeArea(child: TabBarView(children: tabs.map((e) => e.child).toList())),
      ),
    );
  }

  _onTapCalculadora() async {
    final grades = await Get.find<GradesService>().getGrades(asignatura);
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => CalculadoraNotasScreen(grades: grades)));
  }
}

