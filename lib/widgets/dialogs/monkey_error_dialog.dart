import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/error_dialog.dart';

class MonkeyErrorDialog extends StatelessWidget {
  const MonkeyErrorDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) => ErrorDialog(
    contenido: Container(
      height: 100,
      child: FlareActor(
        "assets/animations/monito.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: "rascarse",
      ),
    ),
    mensaje: Text(
      "Ops, parece que metimos la pata. Sólo queda esperar e intentarlo más tarde.",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),
  );
}
