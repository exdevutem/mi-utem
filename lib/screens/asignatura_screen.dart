import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mdi/mdi.dart';

import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/screens/asignatura_estudiantes_tab.dart';
import 'package:mi_utem/screens/asignatura_notas_tab.dart';
import 'package:mi_utem/screens/asignatura_resumen_tab.dart';
import 'package:mi_utem/screens/calculadora_notas_screen.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';

class AsignaturaScreen extends StatefulWidget {
  final Asignatura asignatura;

  AsignaturaScreen({
    Key? key,
    required this.asignatura,
  }) : super(key: key);

  @override
  _AsignaturaScreenState createState() => _AsignaturaScreenState();
}

class _AsignaturaScreenState extends State<AsignaturaScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 1;
  Asignatura? _asignaturaConNotas;
  List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    ReviewService.addScreen("AsignaturaScreen");
    _tabs = [
      AsignaturaResumenTab(asignatura: widget.asignatura),
      AsignaturaNotasTab(
          asignatura: widget.asignatura, onNotas: _onAsignaturaConNotas),
    ];
    if (widget.asignatura.estudiantes != null &&
        widget.asignatura.estudiantes!.length > 0) {
      _tabs.add(AsignaturaEstudiantesTab(asignatura: widget.asignatura));
    }
    _tabController =
        TabController(length: _tabs.length, vsync: this, initialIndex: 1);
    _tabController!.addListener(() {
      setState(() {
        _selectedIndex = _tabController!.index;
      });
    });
  }

  void _onAsignaturaConNotas(Asignatura asignatura) {
    setState(() {
      _asignaturaConNotas = asignatura;
    });
  }

  bool get _mostrarCalculadora {
    return _asignaturaConNotas != null && _selectedIndex == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("${widget.asignatura.nombre}"),
        actions: _mostrarCalculadora
            ? [
                IconButton(
                  icon: Icon(Mdi.calculator),
                  tooltip: "Calculadora",
                  onPressed: () {
                    Get.to(
                      () => CalculadoraNotasScreen(
                          asignaturaInicial: _asignaturaConNotas),
                    );
                  },
                ),
              ]
            : [],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white.withOpacity(0.8),
          tabs: [
            Tab(text: "Resumen"),
            Tab(text: "Notas"),
            // Tab(text: "Estudiantes"),
          ].sublist(0, _tabs.length),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs,
      ),
    );
  }
}
