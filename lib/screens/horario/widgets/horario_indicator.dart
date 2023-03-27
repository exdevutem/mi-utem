import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mi_utem/controllers/horario_controller.dart';

class HorarioIndicator extends StatefulWidget {
  static const _height = 2.0;
  static const _circleRadius = 8.0;

  final HorarioController controller;
  final EdgeInsets initialMargin;
  final double heightByMinute;
  final double maxWidth;
  final Color color;

  const HorarioIndicator({
    Key? key,
    required this.controller,
    required this.initialMargin,
    required this.heightByMinute,
    required this.maxWidth,
    this.color = Colors.red,
  }) : super(key: key);

  @override
  State<HorarioIndicator> createState() => _HorarioIndicatorState();
}

class _HorarioIndicatorState extends State<HorarioIndicator> {
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(
      Duration(seconds: 60),
      (Timer t) => setState(() {}),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double get _centerLineYPosition =>
      (widget.controller.minutesFromStart * widget.heightByMinute);

  double get _startLineXPosition => widget.initialMargin.left;

  @override
  Widget build(BuildContext context) {
    final circleTop = _centerLineYPosition - HorarioIndicator._circleRadius;
    final circleLeft = _startLineXPosition - HorarioIndicator._circleRadius;

    final lineTop = _centerLineYPosition - HorarioIndicator._height / 2;
    final lineLeft = _startLineXPosition;

    return Stack(
      children: [
        if (circleTop > 0 && circleLeft > 0)
          Container(
            margin: EdgeInsets.only(
              top: circleTop,
              left: circleLeft,
            ),
            height: HorarioIndicator._circleRadius * 2,
            width: HorarioIndicator._circleRadius * 2,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius:
                  BorderRadius.circular(HorarioIndicator._circleRadius),
            ),
          ),
        if (lineTop > 0 && lineLeft > 0)
          Container(
            margin: EdgeInsets.only(
              top: lineTop,
              left: lineLeft,
            ),
            height: HorarioIndicator._height,
            width: widget.maxWidth,
            color: widget.color,
          ),
      ],
    );
  }
}
