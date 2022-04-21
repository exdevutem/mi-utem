import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PermisoCovidScreen extends StatelessWidget {
  const PermisoCovidScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text("Permiso Covid")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Column(
              children: [
                Usuario(),
                Divider(thickness: 1, color: Color(0xFFFEEEEE)),
                DetallesPermiso(),
                Divider(thickness: 1, color: Color(0xFFFEEEEE)),
                Center(
                  child: QrImage(
                    data: "https://www.youtube.com/watch?v=OcJQ-sOK5O8",
                    size: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Center(child: Text("Permiso generado el 27/03/2022")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Usuario extends StatelessWidget {
  const Usuario({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(200)),
            child: Image.network(
              "https://static.wikia.nocookie.net/memes-pedia/images/4/4f/Gigachad.jpg/revision/latest?cb=20201122221724&path-prefix=es",
              height: 50.0,
              width: 50.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ernestito Carreño Silva",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFF363636),
                fontSize: 16.0,
              ),
            ),
            Text("19.876.543-2"),
          ],
        ),
      ],
    );
  }
}

class DetallesPermiso extends StatelessWidget {
  const DetallesPermiso({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BloqueDetalle(top: "Motivo", bottom: "Permiso para Funcionarios"),
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: BloqueDetalle(top: "Campus", bottom: "Macul"),
              ),
              Flexible(
                child: BloqueDetalle(top: "Dependencias", bottom: "Biblioteca"),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: BloqueDetalle(top: "Jornada", bottom: "Mañana"),
              ),
              Flexible(
                child: BloqueDetalle(top: "Vigencia", bottom: "Diario"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BloqueDetalle extends StatelessWidget {
  const BloqueDetalle({
    Key? key,
    required this.top,
    required this.bottom,
  }) : super(key: key);

  final String top;
  final String bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            top,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF7F7F7F),
            ),
          ),
          Text(
            bottom,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFF363636),
            ),
          ),
        ],
      ),
    );
  }
}
