import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/controllers/interfaces/calculator_controller.dart';
import 'package:mi_utem/models/asignaturas/asignatura.dart';
import 'package:mi_utem/models/asignaturas/detalles/navigation_tab.dart';
import 'package:mi_utem/repositories/interfaces/asignaturas_repository.dart';
import 'package:mi_utem/screens/asignatura/asignatura_notas_tab.dart';
import 'package:mi_utem/screens/asignatura/asignatura_resumen_tab.dart';
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
  State<AsignaturaDetalleScreen> createState() => _AsignaturaDetalleScreenState();
}

class _AsignaturaDetalleScreenState extends State<AsignaturaDetalleScreen> {

  final _asignaturasRepository = Get.find<AsignaturasRepository>();
  late Asignatura asignatura;
  bool get _mostrarCalculadora => RemoteConfigService.calculadoraMostrar;

  @override
  void initState() {
    asignatura = widget.asignatura;
    super.initState();
  }

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
            final asignatura = await _asignaturasRepository.getDetalleAsignatura(this.asignatura);
            if (asignatura != null) {
              setState(() => this.asignatura = asignatura);
            }
          },
        ),
        initial: true,
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
                  Get.find<CalculatorController>().updateWithGrades(grades);
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

