import 'package:get/get.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/services/grades_service.dart';

class AsignaturaController extends GetxController with StateMixin<Asignatura> {
  late final String asignaturaId;

  AsignaturaController(this.asignaturaId);

  @override
  void onInit() {
    getAsignaturaDetail();
    super.onInit();
  }

  void getAsignaturaDetail({bool refresh = false}) async {
    change(null, status: RxStatus.loading());
    try {
      Asignatura asignatura = await GradesService.getGrades(
        asignaturaId,
        forceRefresh: refresh,
      );
      change(asignatura, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
