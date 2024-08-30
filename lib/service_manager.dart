import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/controllers/grades/grade_update_handler.dart';
import 'package:mi_utem/controllers/horario_controller.dart';
import 'package:mi_utem/core/repositories/secure_storage_repository.dart';
import 'package:mi_utem/core/services/asignaturas_service.dart';
import 'package:mi_utem/core/services/auth_service.dart';
import 'package:mi_utem/core/services/carrera_service.dart';
import 'package:mi_utem/core/services/grades_service.dart';
import 'package:mi_utem/core/services/horario_service.dart';
import 'package:mi_utem/core/services/noticias_service.dart';
import 'package:mi_utem/core/services/permisos_service.dart';
import 'package:mi_utem/core/utils/constants.dart';

Future<void> registerServices() async {
  /* Repositorios (Para conectarse a servicios locales) */
  Get.lazyPut(() => SecureStorageRepository(), fenix: true);


  /* Servicios (Para procesar datos REST) */
  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => AsignaturasService());
  Get.lazyPut(() => CarreraService());
  Get.lazyPut(() => GradesService());
  Get.lazyPut(() => HorarioService());
  Get.lazyPut(() => NoticiasService());
  Get.lazyPut(() => PermisosService());

  /* Controladores (Para procesar datos de interfaz) */
  Get.lazyPut(() => HorarioController(), fenix: true);
  Get.lazyPut(() => CalculatorController(), fenix: true);

  /* Handlers, para administrar algunas cosas de la app */
  Get.lazyPut(() => GradeUpdateHandler());

  final secureStorageRepository = Get.find<SecureStorageRepository>();
  String? username = (await secureStorageRepository.getCredentials())?.username;
  if(username == null) {
    return;
  }

  if(!username.contains("@")) {
    username += "@utem.cl";
  }

  logger.d("[ServiceManager]: ID de usuario: ${md5.convert(utf8.encode(username)).toString()} ($username)");
}