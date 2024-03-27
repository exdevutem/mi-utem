import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/interfaces/horario_controller.dart';
import 'package:mi_utem/services/analytics_service.dart';

class HorarioIndicator extends StatefulWidget {
  static const _height = 2.0;
  static const _circleRadius = 10.0;
  static const _tapAreaRadius = 15.0;

  final EdgeInsets initialMargin;
  final double heightByMinute;
  final double maxWidth;
  final Color color;

  const HorarioIndicator({
    super.key,
    required this.initialMargin,
    required this.heightByMinute,
    required this.maxWidth,
    this.color = Colors.red,
  });

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

  HorarioController _horarioController = Get.find<HorarioController>();

  double get _centerLineYPosition => (_horarioController.minutesFromStart * widget.heightByMinute);

  double get _startLineXPosition => widget.initialMargin.left;

  @override
  Widget build(BuildContext context) {
    final circleTapAreaTop = _centerLineYPosition - HorarioIndicator._circleRadius - HorarioIndicator._tapAreaRadius;
    final circleTapAreaLeft = _startLineXPosition - HorarioIndicator._circleRadius - HorarioIndicator._tapAreaRadius;

    final lineTop = _centerLineYPosition - HorarioIndicator._height / 2;
    final lineLeft = _startLineXPosition;

    return Stack(
      children: [
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
        if (circleTapAreaTop > 0 && circleTapAreaLeft > 0)
          Container(
            margin: EdgeInsets.only(
              top: circleTapAreaTop,
              left: circleTapAreaLeft,
            ),
            child: GestureDetector(
              onTap: () {
                AnalyticsService.logEvent('horario_indicator_dot_tap');
                _horarioController.setIndicatorIsOpen(!_horarioController.indicatorIsOpen.value);
              },
              child: Container(
                padding: EdgeInsets.all(HorarioIndicator._tapAreaRadius),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(HorarioIndicator._tapAreaRadius * 2),
                ),
                child: Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: HorarioIndicator._circleRadius * 2,
                  width: _horarioController.indicatorIsOpen.value ? 50 : HorarioIndicator._circleRadius * 2,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius:
                    BorderRadius.circular(HorarioIndicator._circleRadius),
                  ),
                  child: _horarioController.indicatorIsOpen.value ? Center(
                    child: _TickerTimeText(time: DateTime.now()),
                  ) : Container(),
                )),
              ),
            ),
          ),
      ],
    );
  }
}

class _TickerTimeText extends StatefulWidget {
  final DateTime time;

  const _TickerTimeText({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  State<_TickerTimeText> createState() => __TickerTimeTextState();
}

class __TickerTimeTextState extends State<_TickerTimeText> {
  Timer? _timer;
  bool _showColon = true;

  @override
  void initState() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) => setState(() {
        _showColon = !_showColon;
      }),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timeHour => "${widget.time.hour}";
  String get _timeMinutes => "${widget.time.minute}";

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.fade,
      maxLines: 1,
      text: TextSpan(
        children: [
          TextSpan(
            text: _timeHour,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: ":",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _showColon ? Colors.white : Colors.transparent,
            ),
          ),
          TextSpan(
            text: _timeMinutes,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
