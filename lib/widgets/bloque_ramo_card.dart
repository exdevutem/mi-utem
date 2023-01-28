import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/controllers/horario_controller.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/themes/theme.dart';

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
        child: block?.asignatura == null
            ? _EmptyBlock()
            : _ClassBlock(
                block: block!,
                width: width,
                height: height,
                textColor: textColor,
              ),
      ),
    );
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

  const _ClassBlock({
    Key? key,
    required this.block,
    required this.width,
    required this.height,
    required this.textColor,
    this.color = Colors.teal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HorarioController.to.getColor(block.asignatura!) ?? color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {},
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
