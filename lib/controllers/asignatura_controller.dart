import 'package:get/get.dart';
import 'package:mi_utem/controllers/user_controller.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/grades.dart';
import 'package:mi_utem/services/grades_service.dart';

class AsignaturaController extends GetxController with StateMixin<Asignatura> {
  late final String asignaturaId;
  late final Asignatura? _initialAsignatura;

  Carrera? _selectedCarrera;

  AsignaturaController(this.asignaturaId, {Asignatura? asignatura}) {
    if (asignatura != null) {
      _initialAsignatura = asignatura;
    }
  }

  @override
  void onInit() {
    _selectedCarrera = Get.find<UserController>().selectedCarrera.value;
    if (_selectedCarrera != null) {
      getAsignaturaDetail(Get.find<UserController>().selectedCarrera.value);
    }

    ever<Carrera?>(
      Get.find<UserController>().selectedCarrera,
      (carrera) {
        _selectedCarrera = carrera;
        getAsignaturaDetail(carrera, forceRefresh: true);
      },
    );
    super.onInit();
  }

  Future<void> refreshData() async {
    await getAsignaturaDetail(_selectedCarrera, forceRefresh: true);
  }

  Future<void> getAsignaturaDetail(Carrera? carrera,
      {bool forceRefresh = false}) async {
    final carreraId = carrera?.id;
    if (carreraId != null) {
      change(null, status: RxStatus.loading());
      try {
        Grades grades = await GradesService.getGrades(
          carreraId,
          asignaturaId,
          forceRefresh: forceRefresh,
        );

        Asignatura asignatura = _initialAsignatura!;
        asignatura.grades = grades;

        change(asignatura, status: RxStatus.success());
      } catch (e) {
        change(null, status: RxStatus.error(e.toString()));
      }
    }
  }
}
