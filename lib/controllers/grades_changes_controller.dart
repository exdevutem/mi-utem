import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/controllers/carreras_controller.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/grades.dart';
import 'package:mi_utem/services/asignaturas_service.dart';
import 'package:mi_utem/services/auth_service.dart';
import 'package:mi_utem/services/grades_service.dart';
import 'package:mi_utem/services/notification_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class GradesChangesController {
  static const savedGradesPrefix = 'savedGrades_';
  static const suscribedAsignaturasPrefix = 'suscribedAsignaturas_';

  static final GetStorage box = GetStorage();

  static Future<void> saveGrades(String asignaturaId, Grades grades) async {
    final jsonGrades = grades.toJson();
    jsonGrades['lastUpdate'] = DateTime.now().toIso8601String();

    log('Saving grades for $asignaturaId: $jsonGrades');

    return box.write('$savedGradesPrefix$asignaturaId', jsonGrades);
  }

  static GradeChangeType _getGradeValueChangeType(
    Grades oldGrades,
    Grades updatedGrades,
  ) {
    final oldGradesLength = oldGrades.notasParciales.length;
    final updatedGradesLength = updatedGrades.notasParciales.length;

    if (oldGradesLength == updatedGradesLength) {
      GradeChangeType? currentChange;

      for (int i = 0; i < oldGradesLength; i++) {
        final oldValue = oldGrades.notasParciales[i];
        final updatedValue = updatedGrades.notasParciales[i];

        if (oldValue.nota != updatedValue.nota) {
          if (oldValue.nota == null && updatedValue.nota != null) {
            Sentry.configureScope(
              (scope) => scope.setExtra('newGrade', updatedValue.nota),
            );
            currentChange = GradeChangeType.gradeSetted;
          } else if (oldValue.nota != null && updatedValue.nota == null) {
            currentChange = currentChange ?? GradeChangeType.gradeDeleted;
          } else {
            currentChange = currentChange ?? GradeChangeType.gradeUpdated;
          }
        }
      }

      if (currentChange != null) {
        return currentChange;
      }
    } else {
      Sentry.captureMessage(
        'Asignatura $oldGrades.id has a different number of weighters in _getGradeValueChangeType function',
        level: SentryLevel.warning,
      );
    }
    return GradeChangeType.noChange;
  }

  static bool _hasAWeighterDiferrence(
    Grades oldGrades,
    Grades updatedGrades,
  ) {
    final oldGradesLength = oldGrades.notasParciales.length;
    final updatedGradesLength = updatedGrades.notasParciales.length;

    if (oldGradesLength == updatedGradesLength) {
      for (int i = 0; i < oldGradesLength; i++) {
        final oldWeighter = oldGrades.notasParciales[i];
        final updatedWeighter = updatedGrades.notasParciales[i];

        if (oldWeighter.porcentaje != updatedWeighter.porcentaje) {
          return true;
        }
      }
    } else {
      Sentry.captureMessage(
        'Asignatura $oldGrades.id has a different number of weighters in _hasAWeighterDiferrence function',
        level: SentryLevel.warning,
      );
    }
    return false;
  }

  static bool _hasAGradeWithValue(Grades asignatura) {
    return asignatura.notasParciales.any((element) => element.nota != null);
  }

  static GradeChangeType compareGrades(
    String asignaturaId,
    Grades updatedGrades,
  ) {
    final oldGradesJson = box.read('$savedGradesPrefix$asignaturaId');

    if (oldGradesJson != null) {
      final oldGrades = Grades.fromJson(oldGradesJson);

      log(oldGrades.toString());

      final oldGradesLength = oldGrades.notasParciales.length;
      final updatedGradesLength = updatedGrades.notasParciales.length;

      if (oldGradesLength == 0) {
        if (updatedGradesLength == 0) {
          return GradeChangeType.noChange;
        } else {
          if (_hasAGradeWithValue(updatedGrades)) {
            return GradeChangeType.gradeSetted;
          } else {
            return GradeChangeType.weightersSetted;
          }
        }
      } else {
        if (updatedGradesLength == 0) {
          return GradeChangeType.weightersDeleted;
        } else {
          if (oldGradesLength != updatedGradesLength) {
            return GradeChangeType.weightersUpdated;
          } else {
            if (_hasAWeighterDiferrence(oldGrades, updatedGrades)) {
              return GradeChangeType.weightersUpdated;
            } else {
              return _getGradeValueChangeType(oldGrades, updatedGrades);
            }
          }
        }
      }
    } else {
      log('compareGrades oldGradesJson was null');
    }

    return GradeChangeType.noChange;
  }

  static Future<Map<String, GradeChangeType>> checkIfGradesHasChange() async {
    final isLogged = AuthService.isLoggedIn();

    if (isLogged) {
      final carrera = CarrerasController.to.selectedCarrera.value;
      final carreraId = carrera?.id;

      if (carreraId != null) {
        final suscribedAsignaturasJson =
            box.read('$suscribedAsignaturasPrefix$carreraId');
        List<Asignatura>? suscribedAsignaturas;

        if (suscribedAsignaturasJson == null) {
          final asignaturas =
              await AsignaturasService.getAsignaturas(carreraId);
          final asignaturasJson = asignaturas.map((e) => e.toJson()).toList();
          suscribedAsignaturas = asignaturas;
          box.write('$suscribedAsignaturasPrefix$carreraId', asignaturasJson);
        } else {
          suscribedAsignaturas =
              Asignatura.fromJsonList(suscribedAsignaturasJson);
        }

        for (Asignatura? asignatura in suscribedAsignaturas) {
          final asignaturaId = asignatura?.id;
          if (asignatura != null && asignaturaId != null) {
            final updatedGrades = await GradesService.getGrades(
              carreraId,
              asignaturaId,
              forceRefresh: true,
              saveGrades: false,
            );

            final changeType = compareGrades(
              asignaturaId,
              updatedGrades,
            );

            await saveGrades(asignaturaId, updatedGrades);

            _notificateChange(asignatura, changeType);
          }
        }
      }
    }

    return {};
  }

  static void _notificateChange(Asignatura asignatura, GradeChangeType change) {
    final asignaturaName = asignatura.nombre ?? asignatura.codigo;

    String? title;
    String? body;

    switch (change) {
      case GradeChangeType.gradeSetted:
        title = 'Tienes una nueva nota';
        body = '$asignaturaName: se ha agregado una nota';
        break;
      case GradeChangeType.gradeUpdated:
        title = 'Una nota ha cambiado';
        body = '$asignaturaName: se ha actualizado una nota';
        break;
      case GradeChangeType.gradeDeleted:
        title = 'Una nota se ha borrado';
        body = '$asignaturaName: se ha eliminado una nota';
        break;
      default:
        break;
    }

    if (title != null && body != null) {
      Sentry.captureMessage(
        'Asignatura has changed and notificated',
        level: SentryLevel.debug,
        withScope: (scope) {
          scope.setTag('asignaturaId', asignatura.id.toString());
          scope.setTag('asignaturaCodigo', asignatura.codigo.toString());
          scope.setTag('change', change.toString());
        },
      );

      NotificationService.showGradeChangeNotification(title, body, asignatura);
    } else if (change != GradeChangeType.noChange) {
      Sentry.captureMessage(
        'Asignatura has changed but not notificated',
        level: SentryLevel.debug,
        withScope: (scope) {
          scope.setTag('asignaturaId', asignatura.id.toString());
          scope.setTag('asignaturaCodigo', asignatura.codigo.toString());
          scope.setTag('change', change.toString());
        },
      );
    }
  }
}

enum GradeChangeType {
  weightersSetted,
  weightersUpdated,
  weightersDeleted,
  gradeSetted,
  gradeUpdated,
  gradeDeleted,
  noChange
}
