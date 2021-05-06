/* import 'package:flutter/material.dart';
import 'package:flutter_statusbar/flutter_statusbar.dart';
import 'package:mi_utem/models/avance_malla.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/malla_service.dart';
import 'package:mi_utem/widgets/avance_ramo_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvanceMallaScreen extends StatelessWidget {
  final String carreraCod = "21041";
  final String carrera = "Ingeniería civil en computación menc. Informática";
  final String inicio = "2016 / 1";
  final String termino = "2019 / 1";
  final String plan = "5";
  final String estado = "Regular";
  final String ingreso = "PSU";

  final List<String> nombreRamos = ["QUIC8010 - QUIMICA GENERAL", "MATC8010 - TALLER DE MATEMATICA	", "PPSB0001 - TALLER DE COMUNICACION EFECTIVA	", "PPSB0002 - TALLER PARA EL DESARROLLO DEL PENSAMIENTO LOGICO DEDUCTIVO	"];

  Future<List<AvanceRamoCard>> _getRamos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await Usuario.getToken();
    int usuarioId = prefs.getInt("id");
    

    try {
      var programa = await MallaService.getAlumnoProgramaEstudio(usuarioId.toString(), token);
      var malla = await MallaService.getAvanceMallaAsignatura(programa.plan.id.toString(), usuarioId.toString(), programa.plan.relacionAlumno.toString(), token);
      List<AvanceRamoCard> ramos = [];
      for(var asignatura in malla){
        ramos.add(AvanceRamoCard(
          nombre: asignatura.nombre,
          nivel: asignatura.nivel.toString(),
          nota: asignatura.nota,
          sub: asignatura.descripcion,
        ));
      }      
      return ramos;
    } catch (e) {
      throw e;
    }
  }

  Future<double> _getEscalaMinima(BuildContext context) async {
  }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Avance de malla'),
      ),
      body: FutureBuilder<List<AvanceRamoCard>>(
        future: _getRamos(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return FutureBuilder <double>(
              future: _getEscalaMinima(context),
              builder: (context, datos){
                if(datos.hasData){
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int i){
                      return snapshot.data[i];
                    },
                    itemCount: snapshot.data.length,
                  );
                } else{
                  return Center(
                    child: CircularProgressIndicator()
                  );
                }
              }
            );
          } else if (snapshot.hasError){
            return Text("${snapshot.error}");
          }
        }
      ) 
      //ListView.builder(
        //itemBuilder: (BuildContext conteAvanceMallaScreenxt, int i){
          //return AvanceRamoCard(nombre: nombreRamos[i]);
        //},
        //itemCount: nombreRamos.length,
      //),
    );
  }
} */