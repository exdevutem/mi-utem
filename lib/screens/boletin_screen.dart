/* import 'package:flutter/material.dart';
import 'package:mi_utem/models/boletin_notas.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/horario_service.dart';
import 'package:mi_utem/widgets/info_boletin_card.dart';
import 'package:mi_utem/widgets/semestre_boletin_card.dart';
import 'package:mi_utem/widgets/custom_expansion_tile.dart' as custom;
import 'package:mi_utem/services/boletin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dynamic boletin = [
  {
    "semestre": "Primer Semestre 2016",
    "aprobados": 5,
    "reprobados": 0,
    "convalidados": 0,
    "promedio": 5.6,
    "asignaturas": [
      {
        "nombre": "Introducción A La Ingeniería En Computación",
        "estado": "Aprobado",
        "nota": 5.0
      },
      {
        "nombre": "Química General",
        "estado": "Aprobado",
        "nota": 5.2
      },
      {
        "nombre": "Taller De Comunicación Efectiva",
        "estado": "Aprobado",
        "nota": 5.9
      },
      {
        "nombre": "Taller de Matemática",
        "estado": "Aprobado",
        "nota": 5.7
      },
      {
        "nombre": "Taller Para El Desarrollo Del Pensamiento Lógico Deductivo",
        "estado": "Aprobado",
        "nota": 6.1
      }
    ]
  },
  {
    "semestre": "Segundo Semestre 2016",
    "aprobados": 5,
    "reprobados": 0,
    "convalidados": 0,
    "promedio": 4.8,
    "asignaturas": [
      {
        "nombre": "Álgebra Clásica",
        "estado": "Aprobado",
        "nota": 4.4
      },
      {
        "nombre": "Algoritmos Y Programación",
        "estado": "Aprobado",
        "nota": 5.5
      },
      {
        "nombre": "Cálculo Diferencial",
        "estado": "Aprobado",
        "nota": 4.2
      },
      {
        "nombre": "Dibujo De Ingeniería",
        "estado": "Aprobado",
        "nota": 5.2
      },
      {
        "nombre": "Taller De Ciencia Y Tecnología",
        "estado": "Aprobado",
        "nota": 4.7
      }
    ]
  },
  {
    "semestre": "Primer Semestre 2017",
    "aprobados": 3,
    "reprobados": 1,
    "convalidados": 0,
    "promedio": 4.4,
    "asignaturas": [
      {
        "nombre": "Álgebra Superior",
        "estado": "Reprobado",
        "nota": 2.8
      },
      {
        "nombre": "Cálculo Integral",
        "estado": "Aprobado",
        "nota": 4.1
      },
      {
        "nombre": "Estructura De Datos",
        "estado": "Aprobado",
        "nota": 5.9
      },
      {
        "nombre": "Mecánica Clásica",
        "estado": "Aprobado",
        "nota": 4.9
      },
    ]
  },
  {
    "semestre": "Segundo Semestre 2017",
    "aprobados": 3,
    "reprobados": 1,
    "convalidados": 0,
    "promedio": 4.6,
    "asignaturas": [
      {
        "nombre": "Electromagnetismo",
        "estado": "Reprobado",
        "nota": 3.6
      },
      {
        "nombre": "Ingles I",
        "estado": "Aprobado",
        "nota": 5.7
      },
      {
        "nombre": "Lenguaje De Programación",
        "estado": "Aprobado",
        "nota": 4.0
      },
      {
        "nombre": "Sistemas De Administración",
        "estado": "Aprobado",
        "nota": 5.1
      }
    ]
  },
  {
    "semestre": "Verano 2017",
    "aprobados": 1,
    "reprobados": 0,
    "convalidados": 0,
    "promedio": 5.9,
    "asignaturas": [
      {
        "nombre": "Algebra Superior",
        "estado": "Aprobado",
        "nota": 5.9
      }
    ]
  },
  {
    "semestre": "Segundo Semestre 2018",
    "aprobados": 7,
    "reprobados": 0,
    "convalidados": 0,
    "promedio": 5.2,
    "asignaturas": [
      {
        "nombre": "Circuitos Eléctricos",
        "estado": "Aprobado",
        "nota": 4.0
      },
      {
        "nombre": "Estadistica Y Probabilidades",
        "estado": "Aprobado",
        "nota": 6.0
      },
      {
        "nombre": "Métodos Numéricos",
        "estado": "Aprobado",
        "nota": 5.2
      },
      {
        "nombre": "Óptica Y Ondas",
        "estado": "Aprobado",
        "nota": 4.4
      },
      {
        "nombre": "Sistemas De Información",
        "estado": "Aprobado",
        "nota": 5.8
      },
      {
        "nombre": "Sistemas Económicos",
        "estado": "Aprobado",
        "nota": 5.0
      },
      {
        "nombre": "Tecnología De Computadores",
        "estado": "Aprobado",
        "nota": 6.2
      }
    ]
  },
  {
    "semestre": "Primer Semestre 2019",
    "aprobados": 4,
    "reprobados": 2,
    "convalidados": 0,
    "promedio": 4.2,
    "asignaturas": [
      {
        "nombre": "Arquitectura De Computadores",
        "estado": "Aprobado",
        "nota": 5.1
      },
      {
        "nombre": "Calculo Avanzado",
        "estado": "Reprobado",
        "nota": 2.6
      },
      {
        "nombre": "Grafos Y Lenguajes Formales",
        "estado": "Reprobado",
        "nota": 2.7
      },
      {
        "nombre": "Inferencia Y Procesos Estocásticos",
        "estado": "Aprobado",
        "nota": 4.7
      },
      {
        "nombre": "Ingeniería De Software",
        "estado": "Aprobado",
        "nota": 5.7
      },
      {
        "nombre": "Investigación De Operaciones",
        "estado": "Aprobado",
        "nota": 4.6
      }
    ]
  },
  {
    "semestre": "Segundo Semestre 2019",
    "aprobados": 0,
    "reprobados": 0,
    "convalidados": 0,
    "promedio": null,
    "asignaturas": [
      {
        "nombre": "Calculo Avanzado",
        "estado": "Inscrito",
        "nota": null
      },
      {
        "nombre": "Evaluación De Proyectos Informáticos",
        "estado": "Inscrito",
        "nota": null
      },
      {
        "nombre": "Redes Y Comunicación De Datos",
        "estado": "Inscrito",
        "nota": null
      },
      {
        "nombre": "Taller De Principios De Sustentabilidad",
        "estado": "Inscrito",
        "nota": null
      },
      {
        "nombre": "Taller De Innovación Y Emprendimiento",
        "estado": "Inscrito",
        "nota": null
      },
      {
        "nombre": "Taller De Sistemas De Información",
        "estado": "Inscrito",
        "nota": null
      },
      {
        "nombre": "Teoría De Sistemas",
        "estado": "Inscrito",
        "nota": null
      },
    ]
  }
];


class BoletinScreen extends StatelessWidget {
  final String carrera_cod = "21041";
  final String carrera = "Ingeniería civil en computación menc. Informática";
  final String inicio = "2016 / 1";
  final String termino = "2019 / 1";
  final String plan = "5";
  final String estado = "Regular";
  final String ingreso = "PSU";

  final String semestre = "Primer semestre 2019";
  final int aprobados = 6;
  final int reprobados = 0;
  final int convalidados = 0;
  final double promedio = 5.0;
  final List ramos = [['Cálculo avanzado', 'A', '4.9'], ['Circuitos eléctricos', 'A', '5.1']];

  Future<List<BoletinNotas>> _getBoletines() async {
    
    String token = await Usuario.getToken();
    int usuarioId = prefs.getInt("id");

    try {
      var planes = await HorarioService.getPlanesEstudio(usuarioId.toString(), token);
      var boletines = await BoletinService.getBoletinCursoNotas(planes[0].relacionAlumno.toString(), token);

      return boletines;
    } catch (e) {
      throw e;
    }
  }

  Future<BoletinNotas> _get() async {
    
    String token = await Usuario.getToken();
    int usuarioId = prefs.getInt("id");

    try {
      var programaEstudio = await BoletinService.getAlumnoProgramaEstudio(usuarioId.toString(), token);

      return programaEstudio;
    } catch (e) {
      throw e;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Boletín de notas'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InfoBoletinCard(
              inicio: inicio,
              termino: termino,
              plan: plan,
              estado: estado,
              ingreso: ingreso,
              ),
              new ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: boletin.length,
                itemBuilder: (BuildContext context, int i) {
                  return custom.ExpansionTile(
                    initiallyExpanded: false,
                    leading: Icon(Icons.bookmark),
                    headerBackgroundColor: Color(0xFF009d9b),
                    iconColor: Colors.white,
                    title: Text(boletin[i]["semestre"]),
                    children: <Widget>[
                      SemestreBoletinCard(
                        aprobados: boletin[i]["aprobados"],
                        reprobados: boletin[i]["reprobados"],
                        convalidados: boletin[i]["convalidados"],
                        promedio: boletin[i]["promedio"],
                        ramos: boletin[i]["asignaturas"]
                        ),
                      ],    
                    );
                  }
                ),
              ],
            ),
        ),
      );
  }
} */