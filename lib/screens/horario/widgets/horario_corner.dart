import 'package:flutter/material.dart';

class HorarioCorner extends StatelessWidget {
  final double height;
  final double width;

  const HorarioCorner({
    Key? key,
    required this.height,
    required this.width,
  });

  List<TableRow> get _children => [
        TableRow(
          children: [
            Container(
              height: height,
              width: width,
              color: Color(0xFFBDBDBD),
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
