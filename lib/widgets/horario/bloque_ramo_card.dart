import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services_new/interfaces/controllers/horario_controller.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:watch_it/watch_it.dart';

class ClassBlockCard extends StatelessWidget {
  final BloqueHorario? block;
  final double width;
  final double height;
  final double internalMargin;
  final Color textColor;

  ClassBlockCard({
    Key? key,
    required this.block,
    required this.width,
    required this.height,
    this.internalMargin = 0,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Padding(
        padding: EdgeInsets.all(internalMargin),
        child: block?.asignatura == null ? _EmptyBlock() : _ClassBlock(
          block: block!,
          width: width,
          height: height,
          textColor: textColor,
          onTap: _onTap,
          onLongPress: _onLongPress,
        ),
      ),
    );
  }

  _onTap(BloqueHorario block) {
    AnalyticsService.logEvent(
      "horario_class_block_tap",
      parameters: {
        "asignatura": block.asignatura?.nombre,
        "codigo": block.asignatura?.codigo,
      },
    );

    // TODO: Navegar a la asignatura
  }

  _onLongPress(BloqueHorario block) {
    AnalyticsService.logEvent(
      "horario_class_block_long_press",
      parameters: {
        "asignatura": block.asignatura?.nombre,
        "codigo": block.asignatura?.codigo,
      },
    );

    // TODO: Acá podríamos agregar una vista "rápida" como: Hora, Sala y Profesor.
  }
}

class _EmptyBlock extends StatelessWidget {
  const _EmptyBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MainTheme.lightGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DottedBorder(
        strokeWidth: 2,
        color: MainTheme.grey,
        borderType: BorderType.RRect,
        radius: Radius.circular(15),
        child: Container(),
      ),
    );
  }
}

class _ClassBlock extends StatelessWidget {
  final BloqueHorario block;
  final double width;
  final double height;
  final Color textColor;
  final Color? color;
  final void Function(BloqueHorario)? onTap;
  final void Function(BloqueHorario)? onLongPress;

  const _ClassBlock({
    super.key,
    required this.block,
    required this.width,
    required this.height,
    required this.textColor,
    this.color = Colors.teal,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final _controller = di.get<HorarioController>();

    return Container(
      decoration: BoxDecoration(
        color: _controller.getColor(block.asignatura!) ?? this.color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap != null ? () => onTap?.call(block) : null,
          onLongPress:
              onLongPress != null ? () => onLongPress?.call(block) : null,
          child: Column(
            children: <Widget>[
              HorarioText.classCode(
                block.codigo!,
                color: textColor,
              ),
              HorarioText.className(
                block.asignatura!.nombre!.toUpperCase(),
                color: textColor,
              ),
              HorarioText.classLocation(
                block.sala ?? "Sin sala",
                color: textColor,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      ),
    );
  }
}
