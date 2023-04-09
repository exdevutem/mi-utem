import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/services/asignaturas_service.dart';
import 'package:mi_utem/services/auth_service.dart';
import 'package:mi_utem/services/grades_service.dart';
import 'package:mi_utem/services/notification_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class GradesChangesController {
  static const savedGradesPrefix = 'savedGrades_';
  static const suscribedAsignaturasPrefix = 'suscribedAsignaturas_';

  static final GetStorage box = GetStorage();

  static Future<void> saveGrades(
      String asignaturaId, Asignatura asignatura) async {
    final jsonGrades = asignatura.toJson();
    jsonGrades['lastUpdate'] = DateTime.now().toIso8601String();

    log('Saving grades for $asignaturaId: $jsonGrades');

    return box.write('$savedGradesPrefix$asignaturaId', jsonGrades);
  }

  static GradeChangeType _getGradeValueChangeType(
    Asignatura oldAsignatura,
    Asignatura updatedAsigantura,
  ) {
    final oldAsignaturaLength = oldAsignatura.notasParciales.length;
    final updatedAsiganturaLength = updatedAsigantura.notasParciales.length;

    if (oldAsignaturaLength == updatedAsiganturaLength) {
      GradeChangeType? currentChange;

      for (int i = 0; i < oldAsignaturaLength; i++) {
        final oldValue = oldAsignatura.notasParciales[i];
        final updatedValue = updatedAsigantura.notasParciales[i];

        if (oldValue.nota != updatedValue.nota) {
          if (oldValue.nota == null && updatedValue.nota != null) {
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
        'Asignatura $oldAsignatura.id has a different number of weighters in _getGradeValueChangeType function',
        level: SentryLevel.warning,
      );
    }
    return GradeChangeType.noChange;
  }

  static bool _hasAWeighterDiferrence(
    Asignatura oldAsignatura,
    Asignatura updatedAsigantura,
  ) {
    final oldAsignaturaLength = oldAsignatura.notasParciales.length;
    final updatedAsiganturaLength = updatedAsigantura.notasParciales.length;

    if (oldAsignaturaLength == updatedAsiganturaLength) {
      for (int i = 0; i < oldAsignaturaLength; i++) {
        final oldWeighter = oldAsignatura.notasParciales[i];
        final updatedWeighter = updatedAsigantura.notasParciales[i];

        if (oldWeighter.porcentaje != updatedWeighter.porcentaje) {
          return true;
        }
      }
    } else {
      Sentry.captureMessage(
        'Asignatura $oldAsignatura.id has a different number of weighters in _hasAWeighterDiferrence function',
        level: SentryLevel.warning,
      );
    }
    return false;
  }

  static bool _hasAGradeWithValue(Asignatura asignatura) {
    return asignatura.notasParciales.any((element) => element.nota != null);
  }

  static GradeChangeType compareGrades(
    String asignaturaId,
    Asignatura updatedAsigantura,
  ) {
    final oldAsignaturaJson = box.read('$savedGradesPrefix$asignaturaId');

    if (oldAsignaturaJson != null) {
      final oldAsignatura = Asignatura.fromJson(oldAsignaturaJson);

      log(oldAsignatura.toString());

      final oldAsignaturaLength = oldAsignatura.notasParciales.length;
      final updatedAsiganturaLength = updatedAsigantura.notasParciales.length;

      if (oldAsignaturaLength == 0) {
        if (updatedAsiganturaLength == 0) {
          return GradeChangeType.noChange;
        } else {
          if (_hasAGradeWithValue(updatedAsigantura)) {
            return GradeChangeType.gradeSetted;
          } else {
            return GradeChangeType.weightersSetted;
          }
        }
      } else {
        if (updatedAsiganturaLength == 0) {
          return GradeChangeType.weightersDeleted;
        } else {
          if (oldAsignaturaLength != updatedAsiganturaLength) {
            return GradeChangeType.weightersUpdated;
          } else {
            if (_hasAWeighterDiferrence(oldAsignatura, updatedAsigantura)) {
              return GradeChangeType.weightersUpdated;
            } else {
              return _getGradeValueChangeType(oldAsignatura, updatedAsigantura);
            }
          }
        }
      }
    } else {
      log('compareGrades oldAsignaturaJson was null');
    }

    return GradeChangeType.noChange;
  }

  static Future<Map<String, GradeChangeType>> checkIfGradesHasChange() async {
    final isLogged = AuthService.isLoggedIn();

    if (isLogged) {
      final carreraId = box.read('carreraId');

      if (carreraId != null) {
        final suscribedAsignaturasJson =
            box.read('$suscribedAsignaturasPrefix$carreraId');
        List<Asignatura>? suscribedAsignaturas;

        if (suscribedAsignaturasJson == null) {
          final asignaturas = await AsignaturasService.getAsignaturas();
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
            final updatedAsignatura = await GradesService.getGrades(
              asignaturaId,
              forceRefresh: true,
              saveGrades: false,
            );

            final changeType = compareGrades(
              asignaturaId,
              updatedAsignatura,
            );

            await saveGrades(asignaturaId, updatedAsignatura);

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
