import 'package:flutter/material.dart';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';

class PullToRefresh extends StatelessWidget {
  final Widget? child;
  final Future Function() onRefresh;
  final bool opacityEffect;

  const PullToRefresh({
    super.key,
    this.child,
    required this.onRefresh,
    this.opacityEffect = false
  });

  static double _offsetToArmed = 60;

  @override
  Widget build(BuildContext context) => CustomRefreshIndicator(
    offsetToArmed: _offsetToArmed,
    onRefresh: onRefresh,
    builder: (context, child, controller) => Stack(
      children: [
        AnimatedBuilder(
          child: child,
          animation: controller,
          builder: (context, child) => Opacity(
            opacity: 1.0 - (opacityEffect ? controller.value.clamp(0.0, 1.0) : 0),
            child: Transform.translate(
              offset: Offset(0.0, (_offsetToArmed) * controller.value),
              child: child,
            ),
          ),
        ),
        AnimatedBuilder(
          child: const LoadingIndicator(padding: EdgeInsets.zero),
          animation: controller,
          builder: (context, child) => SafeArea(
            child: Stack(
              children: [
                Container(
                  height: (_offsetToArmed) * controller.value,
                  width: double.infinity,
                  child: Container(
                    height: 30,
                    width: 30,
                    child: SpinKitDoubleBounce(
                      color: MainTheme.primaryColor,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    child: child!,
  );
}
