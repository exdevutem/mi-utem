import 'package:get/get.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/grades.dart';
import 'package:mi_utem/services/grades_service.dart';

class AsignaturaController extends GetxController with StateMixin<Asignatura> {
  late final String asignaturaId;
  late final Asignatura? _initialAsignatura;

  AsignaturaController(this.asignaturaId, {Asignatura? asignatura}) {
    if (asignatura != null) {
      _initialAsignatura = asignatura;
    }
  }

  @override
  void onInit() {
    getAsignaturaDetail();
    super.onInit();
  }

  void getAsignaturaDetail({bool refresh = false}) async {
    change(null, status: RxStatus.loading());
    try {
      Grades grades = await GradesService.getGrades(
        asignaturaId,
        forceRefresh: refresh,
      );

      Asignatura asignatura = _initialAsignatura!;
      asignatura.grades = grades;

      change(asignatura, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
