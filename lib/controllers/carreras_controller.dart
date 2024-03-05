import 'package:get/get.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/carreras_service.dart';

class CarrerasController extends GetxController {
  final carreras = <Carrera>[].obs;
  final selectedCarrera = Rxn<Carrera>();

  static CarrerasController get to => Get.find();

  @override
  void onInit() {
    getCarreras();

    super.onInit();
  }

  void getCarreras() async {
    try {
      final carreras = await CarreraService.getCarreras(forceRefresh: true);

      this.carreras.value = carreras;
      _autoSelectCarreraActiva(carreras);
    } catch(_) {}
  }

  void _autoSelectCarreraActiva(List<Carrera> carreras) {
    final estados = ["Regular", "Causal de Eliminacion"]
        .reversed
        .map((e) => e.toLowerCase())
        .toList();

    carreras.sort(
      (a, b) => estados.indexOf(b.estado!.toLowerCase()).compareTo(
            estados.indexOf(a.estado!.toLowerCase()),
          ),
    );

    Carrera activa = carreras.first;

    AnalyticsService.setCarreraToUser(activa);

    changeSelectedCarrera(activa);
  }

  void changeSelectedCarrera(Carrera carrera) {
    selectedCarrera.value = carrera;
  }
}
