import 'package:get/get.dart';
import 'package:mi_utem/controllers/user_controller.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/carreras_service.dart';

class CarrerasController extends GetxController with StateMixin<List<Carrera>> {
  static CarrerasController get to => Get.find();

  @override
  void onInit() {
    getCarreras();

    ever<Usuario?>(
      Get.find<UserController>().user,
      (carrera) => getCarreras(),
    );

    super.onInit();
  }

  void getCarreras() async {
    change(null, status: RxStatus.loading());

    final carreras = await CarreraService.getCarreras(forceRefresh: true);

    change(carreras, status: RxStatus.success());
    updateUserCarrerasRoles();
    _autoSelectCarreraActiva(carreras);
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

    changeUserSelectedCarrera(activa);
  }

  void updateUserCarrerasRoles() {
    UserController.to.updateCarrerasRoles(state);
  }

  void changeUserSelectedCarrera(Carrera carrera) {
    UserController.to.selectCarrera(carrera);
  }
}
