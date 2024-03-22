import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';

final dynamic carreras = [
  {
    "codigo": 21041,
    "nombre": "Ingeniería Civil En Computación Menc. Informática",
    "plan": 5,
    "icono": 58167,
    "inicio": {"anio": 2018, "semestre": 1},
    "termino": null,
    "estado": {"color": 000000, "descripcion": "Regular"},
    "ingreso": "PSU"
  },
  {
    "codigo": 21030,
    "nombre": "Ingenería En Informática",
    "icono": 57776,
    "plan": 5,
    "inicio": {"anio": 2014, "semestre": 1},
    "termino": null,
    "estado": {"color": 000000, "descripcion": "Regular"},
    "ingreso": "PSU"
  }
];

class CarrerasScreen extends StatefulWidget {
  CarrerasScreen({Key? key}) : super(key: key);

  @override
  _CarrerasScreenState createState() => _CarrerasScreenState();
}

class _CarrerasScreenState extends State<CarrerasScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: Text("Carreras"),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              onTap: () {},
              title: Text(
                carreras[i]["nombre"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('${carreras[i]["codigo"]}/${carreras[i]["plan"]}'),
              /* leading: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                IconData(carreras[i]["icono"], fontFamily: 'MaterialIcons'),
                size: 25,
                color: Colors.white,
              ),
            ), */
              trailing: Text(carreras[i]["estado"]["descripcion"]),
            );
          },
          itemCount: carreras.length,
        ));
  }
}
