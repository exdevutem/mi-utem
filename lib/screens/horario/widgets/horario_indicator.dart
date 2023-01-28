import 'dart:async';

import 'package:flutter/material.dart';

class HorarioIndicator extends StatefulWidget {
  static const _height = 2.0;
  static const _circleRadius = 8.0;

  final EdgeInsets initialMargin;
  final double heightByMinute;
  final double maxWidth;
  final Color color;

  const HorarioIndicator({
    Key? key,
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

  double get _minutesFromEight =>
      DateTime.now().hour * 60 + DateTime.now().minute - 480;

  double get _centerLineYPosition =>
      widget.initialMargin.top + (_minutesFromEight * widget.heightByMinute);

  double get _startLineXPosition => widget.initialMargin.left;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: _centerLineYPosition - HorarioIndicator._circleRadius,
            left: _startLineXPosition - HorarioIndicator._circleRadius,
          ),
          height: HorarioIndicator._circleRadius * 2,
          width: HorarioIndicator._circleRadius * 2,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(HorarioIndicator._circleRadius),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: _centerLineYPosition - HorarioIndicator._height / 2,
            left: _startLineXPosition,
          ),
          height: HorarioIndicator._height,
          width: widget.maxWidth,
          color: widget.color,
        ),
      ],
    );
  }
}
