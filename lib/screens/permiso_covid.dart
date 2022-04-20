import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';

class PermisoCovidScreen extends StatelessWidget {
  const PermisoCovidScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text("Permiso Covid")),
      body: SingleChildScrollView(
        child: Card(
          child: Column(
            children: [
              Usuario(),
              Divider(thickness: 1, color: Color(0xFFFEEEEE)),
              DetallesPermiso(),
              Divider(thickness: 1, color: Color(0xFFFEEEEE)),
              Center(
                child: Image.network(
                  "https://i.pinimg.com/originals/60/c1/4a/60c14a43fb4745795b3b358868517e79.png",
                  height: 300,
                ),
              ),
              Center(child: Text("Permiso generado el 27/03/2022")),
            ],
          ),
        ),
      ),
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Motivo",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7F7F7F),
                ),
              ),
              Text(
                "Permiso para funcionarios",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF363636),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    "Campus",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7F7F7F),
                    ),
                  ),
                  Text(
                    "Macul",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF363636),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Dependencias",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7F7F7F),
                    ),
                  ),
                  Text(
                    "Biblioteca",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF363636),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    "Jornada",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7F7F7F),
                    ),
                  ),
                  Text(
                    "Mañana",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF363636),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Vigencia",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7F7F7F),
                    ),
                  ),
                  Text(
                    "Diario",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF363636),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
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
