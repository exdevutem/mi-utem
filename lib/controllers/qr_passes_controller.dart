import 'package:get/get.dart';
import 'package:mi_utem/controllers/qr_pass_controller.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/services/permisos_covid_service.dart';

class QrPassesController extends GetxController {
  final passes = <PermisoCovid>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    getPasses();
    super.onInit();
  }

  void getPasses({bool refresh = false}) async {
    isLoading.value = true;
    List<PermisoCovid> response =
        await PermisosCovidService.getPermisos(forceRefresh: refresh);
    passes.value = response;
    isLoading.value = false;

    for (var pass in passes) {
      if (pass.id != null) {
        Get.put(
          QrPassController(pass.id!),
          tag: pass.id,
          permanent: true,
        );
      }
    }
  }
}

class QrPassesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QrPassesController());
  }
}
