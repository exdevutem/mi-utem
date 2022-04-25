import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/screens/permiso_covid_screen.dart';
import 'package:mi_utem/services/permisos_covid_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRCodes extends StatefulWidget {
  const QRCodes({Key? key}) : super(key: key);

  @override
  State<QRCodes> createState() => _QRCodesState();
}

class _QRCodesState extends State<QRCodes> {
  late Future<List<PermisoCovid>> permisos;

  @override
  initState() {
    super.initState();

    permisos = PermisosCovidService.getPermisos();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 30.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              children: [
                Text(
                  "PERMISOS ACTIVOS",
                  style: TextStyle(
                    color: Color(0xFF363636),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Ver Todos",
                  style: TextStyle(
                    color: Color(0xFF009D9B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          SizedBox(
            height: 175,
            child: FutureBuilder(
              future: permisos,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.data.length == 0) {
                  return Text('No hay permisos COVID');
                }

                return ListView.builder(
                    itemBuilder: (context, index) =>
                        QRCard(permiso: snapshot.data[index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QRCard extends StatelessWidget {
  const QRCard({Key? key, required this.permiso}) : super(key: key);

  final PermisoCovid permiso;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 175,
      child: Card(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.qr_code_2,
                        color: Colors.black,
                        size: 60.0,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Funcionario"),
                          Text(
                            "Taller - Eventos extraordinarios",
                            style: TextStyle(
                              color: Color(0xFF009D9B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Campus Macul (Macul)",
                            style: TextStyle(
                              color: Color(0xFF363636),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Color(0xFFBDBDBD), thickness: 0.3),
              Expanded(
                flex: 25,
                child: InkWell(
                  onTap: () => {Get.to(PermisoCovidScreen())},
                  child: Center(
                    child: Text(
                      "Ver QR",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
