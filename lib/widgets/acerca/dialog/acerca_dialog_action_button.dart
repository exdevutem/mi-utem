import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/routes.dart';

class AcercaDialogActionButton extends StatefulWidget {

  final bool isActive;
  final int timeLeft;

  const AcercaDialogActionButton({
    Key? key,
    required this.isActive,
    required this.timeLeft,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AcercaDialogActionButtonState();
}

class _AcercaDialogActionButtonState extends State<AcercaDialogActionButton> {

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 10,
    runSpacing: 10,
    crossAxisAlignment: WrapCrossAlignment.center,
    alignment: WrapAlignment.center,
    runAlignment: WrapAlignment.center,
    children: [
      TextButton(
          child: Text(widget.isActive ? "Podrás cerrar en ${widget.timeLeft}" : "Saber más",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (!widget.isActive) {
              Get.back();
              Get.toNamed(Routes.about);
            }
          }
      ),
    ],
  );
}