import 'package:get/get.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/services/asignaturas_service.dart';

class AsignaturaController extends GetxController {
  final asignaturas = [].obs;
  final asignatura = Rxn<Asignatura>(null);
  final isLoading = false.obs;

  static AsignaturaController get to => Get.find();

  @override
  void onInit() {
    getAsignaturas();
    super.onInit();
  }

  void getAsignaturas([bool refresh = false]) async {
    isLoading.value = true;
    List<Asignatura> response =
        await AsignaturasService.getAsignaturas(refresh);
    asignaturas.value = response;
    isLoading.value = false;
  }
}

class AsignaturaBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AsignaturaController(), permanent: true);
  }
}
