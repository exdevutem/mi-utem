import 'package:get/get.dart';
import 'package:mi_utem/controllers/asignatura_controller.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/services/asignaturas_service.dart';

class AsignaturasController extends GetxController {
  final asignaturas = <Asignatura>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    getAsignaturas();
    super.onInit();
  }

  void getAsignaturas({
    bool forceRefresh = false,
  }) async {
    isLoading.value = true;
    List<Asignatura> response =
        await AsignaturasService.getAsignaturas(forceRefresh: forceRefresh);
    asignaturas.value = response;
    isLoading.value = false;

    for (var asignatura in response) {
      if (asignatura.id != null) {
        Get.put(
          AsignaturaController(asignatura.id!),
          tag: asignatura.id,
          permanent: true,
        );
      }
    }
  }
}

class AsignaturasBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AsignaturasController(), permanent: true);
  }
}
