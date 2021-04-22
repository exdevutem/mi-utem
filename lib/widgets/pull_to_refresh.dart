import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';

class PullToRefresh extends StatelessWidget {
  final Widget child;
  final Function onRefresh;
  final bool opacityEffect;

  const PullToRefresh(
      {Key key, this.child, this.onRefresh, this.opacityEffect = false})
      : super(key: key);

  static double _offsetToArmed = 60;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: _offsetToArmed,
      onRefresh: onRefresh,
      builder: (context, child, controller) => Stack(
        children: <Widget>[
          AnimatedBuilder(
            child: child,
            animation: controller,
            builder: (context, child) {
              return Opacity(
                opacity: 1.0 -
                    (opacityEffect ? controller.value.clamp(0.0, 1.0) : 0),
                child: Transform.translate(
                  offset: Offset(0.0, (_offsetToArmed) * controller.value),
                  child: child,
                ),
              );
            },
          ),
          AnimatedBuilder(
            child: LoadingIndicator(padding: EdgeInsets.zero),
            animation: controller,
            builder: (context, child) {
              return SafeArea(
                child: Stack(
                  children: <Widget>[
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
              );
            },
          ),
        ],
      ),
      child: child,
    );
  }
}
