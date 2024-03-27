import 'package:get/get.dart';
import 'package:mi_utem/controllers/implementations/calculator_controller.dart';
import 'package:mi_utem/controllers/implementations/horario_controller.dart';
import 'package:mi_utem/controllers/interfaces/calculator_controller.dart';
import 'package:mi_utem/controllers/interfaces/horario_controller.dart';
import 'package:mi_utem/repositories/implementations/asignaturas_repository.dart';
import 'package:mi_utem/repositories/implementations/auth_repository.dart';
import 'package:mi_utem/repositories/implementations/carreras_repository.dart';
import 'package:mi_utem/repositories/implementations/credentials_repository.dart';
import 'package:mi_utem/repositories/implementations/grades_repository.dart';
import 'package:mi_utem/repositories/implementations/horario_repository.dart';
import 'package:mi_utem/repositories/implementations/noticias_repository.dart';
import 'package:mi_utem/repositories/implementations/permiso_ingreso_repository.dart';
import 'package:mi_utem/repositories/implementations/preferences_repository.dart';
import 'package:mi_utem/repositories/interfaces/asignaturas_repository.dart';
import 'package:mi_utem/repositories/interfaces/auth_repository.dart';
import 'package:mi_utem/repositories/interfaces/carreras_repository.dart';
import 'package:mi_utem/repositories/interfaces/credentials_repository.dart';
import 'package:mi_utem/repositories/interfaces/grades_repository.dart';
import 'package:mi_utem/repositories/interfaces/horario_repository.dart';
import 'package:mi_utem/repositories/interfaces/noticias_repository.dart';
import 'package:mi_utem/repositories/interfaces/permiso_ingreso_repository.dart';
import 'package:mi_utem/repositories/interfaces/preferences_repository.dart';
import 'package:mi_utem/services/implementations/auth_service.dart';
import 'package:mi_utem/services/implementations/carreras_service.dart';
import 'package:mi_utem/services/implementations/grades_service.dart';
import 'package:mi_utem/services/interfaces/auth_service.dart';
import 'package:mi_utem/services/interfaces/carreras_service.dart';
import 'package:mi_utem/services/interfaces/grades_service.dart';

Future<void> registerServices() async {
  /* Repositorios (Para conectarse a la REST Api o servicios locales) */
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImplementation());
  Get.lazyPut<AsignaturasRepository>(() => AsignaturasRepositoryImplementation());
  Get.lazyPut<CredentialsRepository>(() => CredentialsRepositoryImplementation());
  Get.lazyPut<CarrerasRepository>(() => CarrerasRepositoryImplementation());
  Get.lazyPut<GradesRepository>(() => GradesRepositoryImplementation());
  Get.lazyPut<PermisoIngresoRepository>(() => PermisoIngresoRepositoryImplementation());
  Get.lazyPut<NoticiasRepository>(() => NoticiasRepositoryImplementation());
  Get.lazyPut<HorarioRepository>(() => HorarioRepositoryImplementation());

  Get.lazyPut<PreferencesRepository>(() => PreferencesRepositoryImplementation());


  /* Servicios (Para procesar datos REST) */
  Get.lazyPut<AuthService>(() => AuthServiceImplementation());
  Get.lazyPut<CarrerasService>(() => CarrerasServiceImplementation());
  Get.lazyPut<GradesService>(() => GradesServiceImplementation());

  /* Controladores (Para procesar datos de interfaz) */
  Get.lazyPut<HorarioController>(() => HorarioControllerImplementation());
  Get.lazyPut<CalculatorController>(() => CalculatorControllerImplementation());
}