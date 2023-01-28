import 'package:flutter/material.dart';
import 'package:mi_utem/themes/theme.dart';

class BloquePeriodoCard extends StatelessWidget {
  final String? inicio;
  final String? intermedio;
  final String? fin;
  final double height;
  final double width;
  final bool active;
  final Color backgroundColor;

  BloquePeriodoCard({
    Key? key,
    required this.inicio,
    required this.intermedio,
    required this.fin,
    required this.height,
    required this.width,
    this.backgroundColor = MainTheme.lightGrey,
    this.active = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            inicio!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            intermedio!,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 0.5,
              wordSpacing: 1,
              color: Colors.black54,
              fontSize: 14,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            fin!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
