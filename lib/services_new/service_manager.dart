import 'package:mi_utem/services_new/implementations/repositories/asignaturas_repository.dart';
import 'package:mi_utem/services_new/implementations/auth_service.dart';
import 'package:mi_utem/services_new/implementations/carreras_service.dart';
import 'package:mi_utem/services_new/implementations/controllers/calculator_controller.dart';
import 'package:mi_utem/services_new/implementations/controllers/horario_controller.dart';
import 'package:mi_utem/services_new/implementations/repositories/carreras_repository.dart';
import 'package:mi_utem/services_new/implementations/repositories/credentials_repository.dart';
import 'package:mi_utem/services_new/implementations/grades_service.dart';
import 'package:mi_utem/services_new/implementations/repositories/horario_repository.dart';
import 'package:mi_utem/services_new/implementations/repositories/noticias_repository.dart';
import 'package:mi_utem/services_new/implementations/repositories/auth_repository.dart';
import 'package:mi_utem/services_new/implementations/repositories/grades_repository.dart';
import 'package:mi_utem/services_new/implementations/repositories/permiso_ingreso_repository.dart';
import 'package:mi_utem/services_new/interfaces/repositories/asignaturas_repository.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:mi_utem/services_new/interfaces/carreras_service.dart';
import 'package:mi_utem/services_new/interfaces/controllers/calculator_controller.dart';
import 'package:mi_utem/services_new/interfaces/controllers/horario_controller.dart';
import 'package:mi_utem/services_new/interfaces/repositories/carreras_repository.dart';
import 'package:mi_utem/services_new/interfaces/repositories/credentials_repository.dart';
import 'package:mi_utem/services_new/interfaces/grades_service.dart';
import 'package:mi_utem/services_new/interfaces/repositories/horario_repository.dart';
import 'package:mi_utem/services_new/interfaces/repositories/noticias_repository.dart';
import 'package:mi_utem/services_new/interfaces/repositories/auth_repository.dart';
import 'package:mi_utem/services_new/interfaces/repositories/grades_repository.dart';
import 'package:mi_utem/services_new/interfaces/repositories/permiso_ingreso_repository.dart';
import 'package:watch_it/watch_it.dart';

Future<void> registerServices() async {
  /* Repositorios (Para conectarse a la REST Api */
  di.registerLazySingleton<AuthRepository>(() => AuthRepositoryImplementation());
  di.registerLazySingleton<AsignaturasRepository>(() => AsignaturasRepositoryImplementation());
  di.registerLazySingleton<CredentialsRepository>(() => CredentialsRepositoryImplementation());
  di.registerLazySingleton<CarrerasRepository>(() => CarrerasRepositoryImplementation());
  di.registerLazySingleton<GradesRepository>(() => GradesRepositoryImplementation());
  di.registerLazySingleton<PermisoIngresoRepository>(() => PermisoIngresoRepositoryImplementation());
  di.registerLazySingleton<NoticiasRepository>(() => NoticiasRepositoryImplementation());
  di.registerLazySingleton<HorarioRepository>(() => HorarioRepositoryImplementation());


  /* Servicios (Para procesar datos REST) */
  di.registerLazySingleton<AuthService>(() => AuthServiceImplementation());
  di.registerLazySingleton<CarrerasService>(() => CarrerasServiceImplementation());
  di.registerLazySingleton<GradesService>(() => GradesServiceImplementation());

  /* Controladores (Para procesar datos de interfaz) */
  di.registerLazySingleton<HorarioController>(() => HorarioControllerImplementation());
  di.registerLazySingleton<CalculatorController>(() => CalculatorControllerImplementation());
}