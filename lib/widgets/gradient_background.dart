import 'package:flutter/material.dart';
import 'package:mi_utem/themes/theme.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [MainTheme.utemAzul, MainTheme.utemVerde],
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    ),
  );
}