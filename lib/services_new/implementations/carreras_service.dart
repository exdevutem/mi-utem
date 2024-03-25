
import 'package:flutter/widgets.dart';
import 'package:listenable_collections/listenable_collections.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services_new/interfaces/carreras_service.dart';
import 'package:mi_utem/services_new/interfaces/repositories/carreras_repository.dart';
import 'package:watch_it/watch_it.dart';

class CarrerasServiceImplementation implements CarrerasService {

  final _carrerasRepository = di.get<CarrerasRepository>();

  @override
  ListNotifier<Carrera> carreras = ListNotifier();

  @override
  ValueNotifier<Carrera?> selectedCarrera = ValueNotifier(null);

  @override
  Future<void> getCarreras() async {
    logger.d("[CarrerasService#getCarreras]: Obteniendo carreras...");
    final _carreras = await _carrerasRepository.getCarreras();

    carreras.clear();
    carreras.addAll(_carreras);
    autoSelectCarreraActiva();
  }

  @override
  void changeSelectedCarrera(Carrera carrera) => selectedCarrera.value = carrera;

  @override
  void autoSelectCarreraActiva() {
    logger.d("[CarrerasService#autoSelectCarreraActiva]: Seleccionando carrera activa... ${carreras.map((e) => e.toJson()).toList()}");
    final estados = ["Regular", "Causal de Eliminacion"]
        .reversed
        .map((e) => e.toLowerCase())
        .toList();

    logger.d("[CarrerasService#autoSelectCarreraActiva]: Estados: $estados");
    carreras.sort((a,b) => estados.indexOf(b.estado!.toLowerCase()).compareTo(estados.indexOf(a.estado!.toLowerCase())));
    logger.d("[CarrerasService#autoSelectCarreraActiva]: Carreras ordenadas: ${carreras.map((e) => e.toJson()).toList()}");
    final carreraActiva = carreras.first;

    AnalyticsService.setCarreraToUser(carreraActiva);
    changeSelectedCarrera(carreraActiva);
  }

}