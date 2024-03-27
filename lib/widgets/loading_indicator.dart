import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;
  final AnimationController? controller;
  final EdgeInsetsGeometry padding;
  final String? message;

  const LoadingIndicator({
    this.color = const Color(0xFF009d9b),
    this.controller,
    this.padding = const EdgeInsets.all(20),
    this.message,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitDoubleBounce(
              controller: controller,
              color: color,
              size: 40.0,
            ),
            if (message != null) const SizedBox(height: 10),
            if (message != null) Text("$message"),
          ],
        ),
      ),
    ),
  );
}
