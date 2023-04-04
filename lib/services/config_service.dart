import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mdi/mdi.dart';

class ConfigService {
  static const String CREDITOS = 'creditos';
  static const String CLUB_REDES = 'club_redes';
  static const String CLUB_NOMBRE = 'club_nombre';
  static const String CLUB_DESCRIPCION = 'club_descripcion';
  static const String CLUB_LOGO = 'club_logo_url';
  static const String MIUTEM_DESCRIPCION = 'miutem_descripcion';
  static const String MIUTEM_DESARROLLADORES = 'miutem_desarrolladores';
  static const String MIUTEM_PORTADA = 'miutem_portada_url';
  static const String CREDENCIAL_BARRAS = 'miutem_credencial_barras_detalle';
  static const String CREDENCIAL_DISCLAIMER = 'miutem_credencial_disclaimer';
  static const String CREDENCIAL_INFO = 'miutem_credencial_info';
  static const String CREDENCIAL_SIBUTEM_LOGO =
      'miutem_credencial_sibutem_logo_url';
  static const String CALCULADORA_MOSTRAR = 'miutem_calculadora_mostrar';
  static const String HORARIO_ZOOM = 'miutem_horario_zoom';
  static const String HOME_PRONTO_ICONO = 'miutem_home_pronto_icono';
  static const String HOME_PRONTO_TEXTO = 'miutem_home_pronto_texto';
  static const String PRONTO_EG = 'miutem_eg_pronto_texto';
  static const String EG_HABILITADOS = 'miutem_eg_habilitados';
  static const String DRAWER_MENU = 'miutem_drawer_menu';
  static const String GREETINGS = 'miutem_greetings';
  static const String QUICK_MENU = 'miutem_quick_menu';

  static final defaults = <String, dynamic>{
    CREDITOS: jsonEncode(
        ['Hecho con ❤ por el *Club de Desarrollo Experimental* junto a SISEI']),
    CLUB_NOMBRE: "Club de Desarrollo Experimental",
    CLUB_DESCRIPCION:
        "El Club de Desarrollo Experimental es una iniciativa de estudiantes y para estudiantes de la UTEM que busca realzar el lado tecnológico que debería tener la universidad, impulsando y desarrollando ideas y proyectos de caracter innovador.",
    CLUB_LOGO:
        "https://user-images.githubusercontent.com/16374322/114324335-737b6b80-9af7-11eb-841d-9d14aca0f988.png",
    CLUB_REDES: jsonEncode([
      {
        "nombre": "Facebook",
        "color": Color(0xFF3b5998).value,
        "icono": FontAwesomeIcons.facebookF.codePoint,
        "url": "https://www.facebook.com/exdevutem/"
      },
      {
        "nombre": "Twitter",
        "color": Color(0xFF1da1f2).value,
        "icono": FontAwesomeIcons.twitter.codePoint,
        "url": "https://twitter.com/exdevutem"
      },
      {
        "nombre": "Instagram",
        "color": Color(0xFFe1306c).value,
        "icono": FontAwesomeIcons.instagram.codePoint,
        "url": "https://www.instagram.com/exdevutem"
      },
      {
        "nombre": "LinkedIn",
        "color": Color(0xFF0077b5).value,
        "icono": FontAwesomeIcons.linkedinIn.codePoint,
        "url": "https://www.linkedin.com/company/exdevutem/"
      }
    ]),
    MIUTEM_DESCRIPCION:
        "Esta aplicación surgió a principios del 2019 como un proyecto independiente **creado completamente por estudiantes** del Club de Desarrollo Experimental (ExDev) de la UTEM ❤️.  \nActualmente nos encontramos trabajando **junto al equipo de SISEI** para que esta aplicación se convierta en la aplicación institucional oficial de la universidad 🎉  \nToda la información corresponde a datos referenciales, y debe ser validada por la Dirección General de Docencia.",
    MIUTEM_PORTADA:
        "https://user-images.githubusercontent.com/16374322/114324046-16cb8100-9af6-11eb-9a95-11da425e2fbd.png",
    MIUTEM_DESARROLLADORES: jsonEncode([
      {
        "nombre": "Sebastián Albornoz Medina",
        "rol": "Desarrollador",
        "fotoUrl":
            "https://user-images.githubusercontent.com/16374322/79176618-b87a9e00-7dce-11ea-905e-7a20db350850.jpeg",
        "redes": [
          {
            "nombre": "LinkedIn",
            "color": Color(0xFF0077b5).value,
            "icono": FontAwesomeIcons.linkedinIn.codePoint,
            "url":
                "https://www.linkedin.com/in/sebastian-albornoz-medina-a8676a177/"
          },
          {
            "nombre": "GitHub",
            "color": Color(0xFF333333).value,
            "icono": FontAwesomeIcons.github.codePoint,
            "url": "https://github.com/Ballena0"
          }
        ]
      },
      {
        "nombre": "Juan Avendaño Nuñez",
        "rol": "Desarrollador",
        "fotoUrl":
            "https://user-images.githubusercontent.com/16374322/79176616-b7497100-7dce-11ea-85fe-bd3746792429.jpeg",
        "redes": [
          {
            "nombre": "LinkedIn",
            "color": Color(0xFF0077b5).value,
            "icono": FontAwesomeIcons.linkedinIn.codePoint,
            "url": "https://www.linkedin.com/in/javendanon/"
          },
          {
            "nombre": "GitHub",
            "color": Color(0xFF333333).value,
            "icono": FontAwesomeIcons.github.codePoint,
            "url": "https://github.com/Javendanon"
          }
        ]
      },
      {
        "nombre": "Felipe Flores Vivanco",
        "rol": "Desarrollador",
        "fotoUrl":
            "https://user-images.githubusercontent.com/16374322/79176612-b6184400-7dce-11ea-97ce-61fe242601a8.jpeg",
        "redes": [
          {
            "nombre": "LinkedIn",
            "color": Color(0xFF0077b5).value,
            "icono": FontAwesomeIcons.linkedinIn.codePoint,
            "url": "https://www.linkedin.com/in/felipe-flores-4895001ba/"
          },
          {
            "nombre": "GitHub",
            "color": Color(0xFF333333).value,
            "icono": FontAwesomeIcons.github.codePoint,
            "url": "https://github.com/Spipe/"
          },
        ]
      },
      {
        "nombre": "Mariam V. Maldonado Marin",
        "rol": "Desarrolladora",
        "fotoUrl":
            "https://user-images.githubusercontent.com/16374322/79176677-dea03e00-7dce-11ea-8387-1d78b1f6d74a.jpeg",
        "redes": [
          {
            "nombre": "LinkedIn",
            "color": Color(0xFF0077b5).value,
            "icono": FontAwesomeIcons.linkedinIn.codePoint,
            "url": "https://www.linkedin.com/in/mariam-vmm/"
          },
          {
            "nombre": "GitHub",
            "color": Color(0xFF333333).value,
            "icono": FontAwesomeIcons.github.codePoint,
            "url": "https://github.com/mariam6697"
          }
        ]
      },
      {
        "nombre": "Jorge Verdugo Chacón",
        "rol": "Desarrollador",
        "fotoUrl":
            "https://user-images.githubusercontent.com/16374322/79077710-6dc72c00-7cd1-11ea-89bb-3965e53c35e0.jpeg",
        "redes": [
          {
            "nombre": "LinkedIn",
            "color": Color(0xFF0077b5).value,
            "icono": FontAwesomeIcons.linkedinIn.codePoint,
            "url": "https://www.linkedin.com/in/jorgeverdugoch/"
          },
          {
            "nombre": "GitHub",
            "color": Color(0xFF333333).value,
            "icono": FontAwesomeIcons.github.codePoint,
            "url": "https://github.com/mapacheverdugo/"
          }
        ]
      },
      {
        "nombre": "Javiera Vergara Navarro",
        "rol": "Desarrolladora / Ilustradora",
        "fotoUrl":
            "https://user-images.githubusercontent.com/16374322/105080871-33fd3000-5a70-11eb-9db1-df66668957c3.png",
        "redes": [
          {
            "nombre": "LinkedIn",
            "color": Color(0xFF0077b5).value,
            "icono": FontAwesomeIcons.linkedinIn.codePoint,
            "url": "https://www.linkedin.com/in/javieravergara/"
          },
          {
            "nombre": "GitHub",
            "color": Color(0xFF333333).value,
            "icono": FontAwesomeIcons.github.codePoint,
            "url": "https://github.com/PollitoMayo/"
          },
          {
            "nombre": "DeviantArt",
            "color": Color(0xFF4dc47d).value,
            "icono": FontAwesomeIcons.deviantart.codePoint,
            "url": "https://www.deviantart.com/pollitomayo"
          }
        ]
      }
    ]),
    CREDENCIAL_BARRAS: "Código de barras compatible con Sistema de Bibliotecas",
    CREDENCIAL_INFO:
        "**Mayor información:** \n\n [biblioteca.utem.cl](https://biblioteca.utem.cl/)\n\nEn caso de dudas con su credencial, consultar a su biblioteca o al correo electrónico [**credenciales@utem.cl**](mailto:credenciales@utem.cl)",
    CREDENCIAL_DISCLAIMER:
        "**Esta credencial virtual es generada automáticamente y es de uso personal e intransferible. El atraso en la devolución de libros y revistas será sancionado por la biblioteca.**",
    CREDENCIAL_SIBUTEM_LOGO:
        "https://user-images.githubusercontent.com/16374322/114325090-42ea0080-9afc-11eb-9cc8-ef4846d4ad8f.jpg",
    CALCULADORA_MOSTRAR: true,
    HORARIO_ZOOM: 0.5,
    HOME_PRONTO_ICONO: Icons.pregnant_woman.codePoint,
    HOME_PRONTO_TEXTO: "Se están gestando nuevas funciones 😎",
    PRONTO_EG: "Este recurso no esta disponible",
    EG_HABILITADOS: true,
    DRAWER_MENU: jsonEncode([
      {
        "nombre": "Perfil",
        "icono": {
          "codePoint": Icons.person.codePoint,
          "fontFamily": 'MaterialIcons'
        },
        "mostrar": true,
        "esNuevo": false
      },
      {
        "nombre": "Asignaturas",
        "icono": {
          "codePoint": Icons.book.codePoint,
          "fontFamily": 'MaterialIcons'
        },
        "mostrar": true,
        "esNuevo": false
      },
      {
        "nombre": "Horario",
        "icono": {
          "codePoint": Mdi.clockTimeEight.codePoint,
          "fontFamily": 'Material Design Icons',
          "fontPackage": "mdi"
        },
        "mostrar": true,
        "esNuevo": false
      },
      {
        "nombre": "Credencial",
        "icono": {
          "codePoint": Mdi.cardAccountDetails.codePoint,
          "fontFamily": 'Material Design Icons',
          "fontPackage": "mdi"
        },
        "mostrar": true,
        "esNuevo": true
      },
      // {
      //   "nombre": "Docentes",
      //   "icono": {
      //     "codePoint": Mdi.accountTie.codePoint,
      //     "fontFamily": 'Material Design Icons',
      //     "fontPackage": "mdi"
      //   },
      //   "mostrar": true,
      //   "esNuevo": true
      // },
    ]),
    GREETINGS: jsonEncode(['Que gusto verte, **%name**']),
    QUICK_MENU: jsonEncode([
      {
        "nombre": "Notas",
        "degradado": {
          "colors": ["#ff00cc", "#333399"],
          "begin": [-1, 0],
          "end": [1, 0]
        },
        "icono": {
          "codePoint": Icons.book.codePoint,
          "fontFamily": 'MaterialIcons'
        },
        "route": "/AsignaturasScreen",
      },
      {
        "nombre": "Calculadora",
        "degradado": {
          "colors": ["#000046", "#1CB5E0"],
          "begin": [0, -1],
          "end": [0, 1]
        },
        "icono": {
          "codePoint": Mdi.calculator.codePoint,
          "fontFamily": "Material Design Icons",
          "fontPackage": "mdi"
        },
        "route": "/CalculadoraNotasScreen"
      },
      {
        "nombre": "Horario",
        "degradado": {
          "colors": ["#F55B9A", "#F9B16E"],
          "begin": [-1, -1],
          "end": [1, 1]
        },
        "icono": {
          "codePoint": Mdi.clockTimeEight.codePoint,
          "fontFamily": 'Material Design Icons',
          "fontPackage": "mdi"
        },
        "route": "/HorarioScreen",
      },
      {
        "nombre": "Credencial",
        "degradado": {
          "colors": ["#00F260", "#0575E6"],
          "begin": [-1, 1],
          "end": [1, -1]
        },
        "icono": {
          "codePoint": Mdi.cardAccountDetails.codePoint,
          "fontFamily": 'Material Design Icons',
          "fontPackage": "mdi"
        },
        "route": "/CredencialScreen",
      },
    ])
  };

  static ConfigService? _instance;

  static late FirebaseRemoteConfig _remoteConfig;

  static FirebaseRemoteConfig get config => _remoteConfig;

  static Future<ConfigService?> getInstance() async {
    if (_instance == null) {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await initialize();
    } else {
      await update();
    }
    return _instance;
  }

  static Future initialize() async {
    try {
      await _remoteConfig.setDefaults(defaults);
      await _remoteConfig.fetchAndActivate();
    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
    }
  }

  static Future update() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
          minimumFetchInterval: Duration.zero,
          fetchTimeout: Duration(minutes: 1)));
      await _remoteConfig.fetchAndActivate();
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
          minimumFetchInterval: Duration(hours: 12),
          fetchTimeout: Duration(minutes: 1)));
    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
    }
  }
}
