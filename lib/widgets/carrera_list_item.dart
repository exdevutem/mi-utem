/* import 'package:flutter/material.dart';

import 'package:mi_utem/protos/horario.pb.dart';

class CarreraListItem extends StatelessWidget{
  final String nombre, estado;
  final int plan, codigo;

  CarreraListItem({
    Key key,
    this.nombre,
    this.estado,
    this.plan,
    this.codigo
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Código y plan: $codigo/$plan'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Estado: $estado'),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          
      ),
      onTap: () {
        print(nombre);
      },
    );
  }
} */
