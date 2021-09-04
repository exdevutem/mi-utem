import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/themes/theme.dart';

class NotaListItem extends StatefulWidget {
  final Evaluacion? evaluacion;
  final bool esSimulacion;
  final Function? onChanged;

  NotaListItem({
    Key? key,
    this.esSimulacion = false,
    this.evaluacion,
    this.onChanged
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotaListItemState();
}

class _NotaListItemState extends State<NotaListItem> {

  MaskedTextController _notaController = new MaskedTextController(mask: '0.0');
  MaskedTextController _porcentajeController = new MaskedTextController(mask: '000');

  @override
  void initState() {
    super.initState();
    if (widget.evaluacion!.porcentaje != null) {
      _porcentajeController.text = widget.evaluacion!.porcentaje.toString();
    }
    if (widget.evaluacion!.nota != null) {
      _notaController.text = widget.evaluacion!.nota?.toStringAsFixed(1) ?? "";
    }
  }

  @override
  void dispose() {
    super.dispose();
    _notaController.dispose();
    _porcentajeController.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: Center(
              child: Container(
                width: 60,
                child: Text(widget.evaluacion!.etiqueta)
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: Container(
                width: 60,
                child: TextField(
                  controller: _notaController,
                  enabled: widget.esSimulacion,
                  onChanged: (String valor) => widget.onChanged!(valor, _porcentajeController.text),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: widget.esSimulacion ? "0.0" : "--",
                    disabledBorder: MainTheme.theme.inputDecorationTheme.border!.copyWith(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                )
              ) 
            )
          ),
          Flexible(
            child: Center(
              child: Container(
                width: 60,
                child: TextField(
                  controller: _porcentajeController,
                  textAlign: TextAlign.center,
                  onChanged: (String valor) => widget.onChanged!(_notaController.text, valor),
                  enabled: widget.esSimulacion,
                  decoration: InputDecoration(
                    hintText: "Peso",
                    suffixText: "%",
                    disabledBorder: MainTheme.theme.inputDecorationTheme.border!.copyWith(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )
                    )
                  ),
                  keyboardType: TextInputType.number,
                )
              ) 
            )
          )
        ],
      ),
    );
  }
}