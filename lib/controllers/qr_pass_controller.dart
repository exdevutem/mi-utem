import 'package:get/get.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/services/permisos_covid_service.dart';

class QrPassController extends GetxController with StateMixin<PermisoCovid> {
  late final String passId;

  QrPassController(this.passId);

  @override
  void onInit() {
    getPassDetails();
    super.onInit();
  }

  void getPassDetails({bool refresh = false}) async {
    change(null, status: RxStatus.loading());
    try {
      PermisoCovid pass = await PermisosCovidService.getDetallesPermiso(
        passId,
        forceRefresh: refresh,
      );
      change(pass, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
