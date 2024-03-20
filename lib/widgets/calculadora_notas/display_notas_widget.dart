import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/calculadora_notas/modo_simulacion_widget.dart';
import 'package:mi_utem/widgets/calculadora_notas/nota_examen_display_widget.dart';
import 'package:mi_utem/widgets/calculadora_notas/nota_final_display_widget.dart';
import 'package:mi_utem/widgets/calculadora_notas/nota_presentacion_display_widget.dart';

class DisplayNotasWidget extends StatelessWidget {

  const DisplayNotasWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Card(
    child: Stack(
      alignment: Alignment.center,
      children: [
        const ModoSimulacionWidget(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const NotaFinalDisplayWidget(),
              const SizedBox(width: 10),
              Container(
                height: 80,
                width: 0.5,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const NotaExamenDisplayWidget(),
                  const SizedBox(height: 10),
                  const NotaPresentacionDisplayWidget(),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
