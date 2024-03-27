import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/acerca/acerca_screen.dart';

class AcercaDialogActionButton extends StatefulWidget {

  final bool isActive;
  final int timeLeft;

  const AcercaDialogActionButton({
    super.key,
    required this.isActive,
    required this.timeLeft,
  });

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
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if (!widget.isActive) {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => AcercaScreen()));
          }
        },
      ),
    ],
  );
}