import 'package:flutter/material.dart';
import 'package:mi_utem/controllers/horario_controller.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/screens/horario/widgets/horario_blocks_content.dart';
import 'package:mi_utem/screens/horario/widgets/horario_corner.dart';
import 'package:mi_utem/screens/horario/widgets/horario_days_header.dart';
import 'package:mi_utem/screens/horario/widgets/horario_indicator.dart';
import 'package:mi_utem/screens/horario/widgets/horario_periods_header.dart';

class HorarioMainScroller extends StatefulWidget {
  static const double blockWidth = 320.0;
  static const double blockHeight = 200.0;
  static const double blockInternalMargin = 10.0;
  static const double dayHeight = 50.0;
  static const double dayWidth = blockWidth;
  static const double periodHeight = blockHeight;
  static const double periodWidth = 65.0;
  static const double borderWidth = 2.0;

  static const double defaultMaxScale = 1.0;
  static const double defaultMinScale = 0.1;

  final Horario horario;
  final bool showActive;
  final HorarioController controller;

  const HorarioMainScroller({
    Key? key,
    required this.horario,
    required this.controller,
    this.showActive = true,
  }) : super(key: key);

  @override
  _HorarioMainScrollerState createState() => _HorarioMainScrollerState();

  static double get daysWidth => dayWidth * HorarioController.daysCount;
  static double get periodsHeight =>
      periodHeight * HorarioController.periodsCount;

  static double get totalWidth => daysWidth + periodWidth;
  static double get totalHeight => periodsHeight + dayHeight;

  Widget get _horarioBlocksContent => HorarioBlocksContent(
        horario: horario,
        blockHeight: blockHeight,
        blockWidth: blockWidth,
        blockInternalMargin: blockInternalMargin,
      );

  Widget get _horarioDaysHeader => HorarioDaysHeader(
        controller: controller,
        horario: horario,
        height: dayHeight,
        dayWidth: dayWidth,
        showActiveDay: showActive,
      );

  Widget get _horarioPeriodsHeader => HorarioPeriodsHeader(
        controller: controller,
        horario: horario,
        width: periodWidth,
        periodHeight: periodHeight,
        showActivePeriod: showActive,
      );

  Widget get _horarioCorner => HorarioCorner(
        height: dayHeight,
        width: periodWidth,
      );

  Widget get basicHorario => Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                _horarioCorner,
                _horarioDaysHeader,
              ],
            ),
            Row(
              children: [
                _horarioPeriodsHeader,
                _horarioBlocksContent,
              ],
            )
          ],
        ),
      );
}

class _HorarioMainScrollerState extends State<HorarioMainScroller> {
  @override
  void initState() {
    widget.controller.blockContentController.addListener(() {
      setState(() {});
    });
    widget.controller.cornerController.addListener(() {
      setState(() {});
    });
    widget.controller.periodHeaderController.addListener(() {
      setState(() {});
    });
    widget.controller.daysHeaderController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            height: HorarioMainScroller.periodsHeight,
            width: HorarioMainScroller.daysWidth,
            margin: EdgeInsets.only(
              top: HorarioMainScroller.dayHeight * widget.controller.zoom.value,
              left: HorarioMainScroller.periodWidth *
                  widget.controller.zoom.value,
            ),
            child: InteractiveViewer(
              transformationController:
                  widget.controller.blockContentController,
              maxScale: HorarioMainScroller.defaultMaxScale,
              minScale: HorarioMainScroller.defaultMinScale,
              alignPanAxis: false,
              clipBehavior: Clip.none,
              constrained: false,
              onInteractionUpdate: (interaction) {},
              child: SafeArea(
                child: widget._horarioBlocksContent,
              ),
            ),
          ),
          Container(
            width: HorarioMainScroller.daysWidth,
            height: HorarioMainScroller.dayHeight,
            margin: EdgeInsets.only(
              left: HorarioMainScroller.periodWidth *
                  widget.controller.zoom.value,
            ),
            child: InteractiveViewer(
              transformationController: widget.controller.daysHeaderController,
              maxScale: HorarioMainScroller.defaultMaxScale,
              minScale: HorarioMainScroller.defaultMinScale,
              alignPanAxis: false,
              scaleEnabled: false,
              clipBehavior: Clip.none,
              constrained: false,
              onInteractionUpdate: (interaction) {},
              child: SafeArea(
                child: widget._horarioDaysHeader,
              ),
            ),
          ),
          Container(
            width: HorarioMainScroller.periodWidth,
            height: HorarioMainScroller.dayHeight,
            child: InteractiveViewer(
              transformationController: widget.controller.cornerController,
              maxScale: HorarioMainScroller.defaultMaxScale,
              minScale: HorarioMainScroller.defaultMinScale,
              alignPanAxis: false,
              scaleEnabled: false,
              panEnabled: false,
              clipBehavior: Clip.none,
              constrained: false,
              onInteractionUpdate: (interaction) {},
              child: SafeArea(
                child: widget._horarioCorner,
              ),
            ),
          ),
          Container(
            width: HorarioMainScroller.periodWidth,
            height: HorarioMainScroller.periodsHeight,
            margin: EdgeInsets.only(
              top: HorarioMainScroller.dayHeight * widget.controller.zoom.value,
            ),
            child: InteractiveViewer(
              transformationController:
                  widget.controller.periodHeaderController,
              maxScale: HorarioMainScroller.defaultMaxScale,
              minScale: HorarioMainScroller.defaultMinScale,
              alignPanAxis: false,
              scaleEnabled: false,
              clipBehavior: Clip.none,
              constrained: false,
              onInteractionUpdate: (interaction) {},
              child: SafeArea(
                child: Stack(
                  children: [
                    widget._horarioPeriodsHeader,
                    HorarioIndicator(
                      controller: widget.controller,
                      maxWidth: HorarioMainScroller.daysWidth,
                      initialMargin: EdgeInsets.only(
                        top: HorarioMainScroller.dayHeight,
                        left: HorarioMainScroller.periodWidth,
                      ),
                      heightByMinute: HorarioMainScroller.blockHeight / 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
