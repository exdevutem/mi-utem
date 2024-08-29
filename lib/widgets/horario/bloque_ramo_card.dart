import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/horario.dart';
import 'package:mi_utem/core/services/asignaturas_service.dart';
import 'package:mi_utem/core/services/grades_service.dart';
import 'package:mi_utem/screens/asignatura/detalle/asignatura_detalle_screen.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/widgets/horario/bloque_clase.dart';
import 'package:mi_utem/widgets/horario/bloque_vacio.dart';
import 'package:mi_utem/widgets/horario/modals/asignatura_vista_previa_modal.dart';
import 'package:mi_utem/widgets/loading/loading_dialog.dart';
import 'package:mi_utem/widgets/snackbar.dart';

class ClassBlockCard extends StatelessWidget {
  final BloqueHorario? block;
  final double width;
  final double height;
  final double internalMargin;
  final Color textColor;

  const ClassBlockCard({
    super.key,
    required this.block,
    required this.width,
    required this.height,
    this.internalMargin = 0,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: width,
    child: Padding(
      padding: EdgeInsets.all(internalMargin),
      child: block?.asignatura == null ? BloqueVacio() : BloqueClase(
        block: block!,
        width: width,
        height: height,
        textColor: textColor,
        onTap: (block) => _onTap(block, context),
        onLongPress: (block) => _onLongPress(block, context),
      ),
    ),
  );

  _onTap(BloqueHorario block, BuildContext context) async {
    showLoadingDialog(context);
    final asignatura = (await Get.find<AsignaturasService>().getAsignaturas()).firstWhereOrNull((asignatura) => asignatura.id == block.asignatura?.id || asignatura.codigo == block.asignatura?.codigo);
    if(asignatura == null) {
      Navigator.pop(context);
      showErrorSnackbar(context, 'No se pudo cargar la asignatura. Intenta más tarde.');
      return;
    }
    final grades = await Get.find<GradesService>().getGrades(asignatura);

    AnalyticsService.logEvent("horario_class_block_tap", parameters: {
      "asignatura": asignatura.nombre,
      "codigo": asignatura.codigo,
    });
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => AsignaturaDetalleScreen(
      asignatura: asignatura.copyWith(grades: grades),
    )));
  }

  _onLongPress(BloqueHorario block, BuildContext context) async {
    showLoadingDialog(context);
    final asignatura = (await Get.find<AsignaturasService>().getAsignaturas()).firstWhereOrNull((asignatura) => asignatura.id == block.asignatura?.id || asignatura.codigo == block.asignatura?.codigo);
    if(asignatura == null) {
      Navigator.pop(context);
      showErrorSnackbar(context, 'No se pudo cargar la asignatura. Intenta más tarde.');
      return;
    }

    AnalyticsService.logEvent("horario_class_block_long_press", parameters: {
      "asignatura": block.asignatura?.nombre,
      "codigo": block.asignatura?.codigo,
    });
    Navigator.pop(context);
    showModalBottomSheet(context: context, builder: (ctx) => AsignaturaVistaPreviaModal(asignatura: asignatura, bloque: block), shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))));
  }
}
