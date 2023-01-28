import 'package:flutter/material.dart';
import 'package:mi_utem/themes/theme.dart';

class HorarioCorner extends StatelessWidget {
  final double height;
  final double width;
  final Color backgroundColor;

  const HorarioCorner({
    Key? key,
    required this.height,
    required this.width,
    this.backgroundColor = MainTheme.lightGrey,
  });

  List<TableRow> get _children => [
        TableRow(
          children: [
            Container(
              height: height,
              width: width,
              color: backgroundColor,
            ),
          ],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: FixedColumnWidth(width),
      border: TableBorder(
        right: BorderSide(
          color: Color(0xFFBDBDBD),
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      children: _children,
    );
  }
}
