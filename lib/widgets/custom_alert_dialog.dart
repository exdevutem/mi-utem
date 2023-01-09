import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String titulo;
  final String? emoji;
  final String descripcion;
  final String confirmarTextoBoton;
  final String cancelarTextoBoton;
  final VoidCallback? onCancelar;
  final VoidCallback? onConfirmar;

  CustomAlertDialog(
      {Key? key,
      required this.titulo,
      required this.descripcion,
      this.cancelarTextoBoton = "Cancelar",
      this.confirmarTextoBoton = "Confirmar",
      this.onCancelar,
      this.emoji,
      this.onConfirmar})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    child: Card(
                      margin: EdgeInsets.all(40),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.titulo,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            if (widget.emoji != null) Container(height: 20),
                            if (widget.emoji != null)
                              Text(
                                widget.emoji!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 50,
                                ),
                              ),
                            Container(height: 20),
                            Text(
                              widget.descripcion,
                              textAlign: TextAlign.center,
                            ),
                            Container(height: 20),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              runAlignment: WrapAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () async {
                                    widget.onCancelar!();
                                  },
                                  child: Text(widget.cancelarTextoBoton),
                                ),
                                TextButton(
                                  onPressed: () {
                                    widget.onConfirmar!();
                                  },
                                  child: Text(widget.confirmarTextoBoton),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
