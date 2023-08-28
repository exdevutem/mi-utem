import 'package:get/get.dart';
import 'package:mi_utem/controllers/asignatura_controller.dart';
import 'package:mi_utem/controllers/carreras_controller.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/services/asignaturas_service.dart';

class AsignaturasController extends GetxController
    with StateMixin<List<Asignatura>> {
  @override
  void onInit() {
    change(null, status: RxStatus.loading());

    if (Get.find<CarrerasController>().selectedCarrera.value != null) {
      getAsignaturas(Get.find<CarrerasController>().selectedCarrera.value);
    }

    ever<Carrera?>(
      Get.find<CarrerasController>().selectedCarrera,
      (carrera) => getAsignaturas(carrera, forceRefresh: true),
    );
    super.onInit();
  }

  void getAsignaturas(
    Carrera? carrera, {
    bool forceRefresh = false,
  }) async {
    change(null, status: RxStatus.loading());

    final carreraId = carrera?.id;

    if (carreraId == null) {
      change(null, status: RxStatus.error("No hay carrera seleccionada"));
      return;
    }

    List<Asignatura> response = await AsignaturasService.getAsignaturas(
      carreraId,
      forceRefresh: forceRefresh,
    );

    change(response, status: RxStatus.success());

    for (var asignatura in response) {
      if (asignatura.id != null) {
        Get.put(
          AsignaturaController(asignatura.id!, asignatura: asignatura),
          tag: asignatura.id,
          permanent: true,
        );
      }
    }
  }

  void refreshAsignaturas() {
    final carrera = Get.find<CarrerasController>().selectedCarrera.value;
    getAsignaturas(carrera, forceRefresh: true);
  }
}

class AsignaturasBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AsignaturasController(), permanent: true);
  }
}
