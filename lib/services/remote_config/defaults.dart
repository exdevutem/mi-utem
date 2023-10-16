part of 'remote_config.dart';

final _defaults = <String, dynamic>{
  RemoteConfigServiceKeys.banners: jsonEncode([]),
  RemoteConfigServiceKeys.creditos: jsonEncode(
      ['Hecho con ❤ por el *Club de Desarrollo Experimental* junto a SISEI']),
  RemoteConfigServiceKeys.clubNombre: "Club de Desarrollo Experimental",
  RemoteConfigServiceKeys.clubDescripcion:
      "El Club de Desarrollo Experimental es una iniciativa de estudiantes y para estudiantes de la UTEM que busca realzar el lado tecnológico que debería tener la universidad, impulsando y desarrollando ideas y proyectos de caracter innovador.",
  RemoteConfigServiceKeys.clubLogo:
      "https://user-images.githubusercontent.com/16374322/114324335-737b6b80-9af7-11eb-841d-9d14aca0f988.png",
  RemoteConfigServiceKeys.clubRedes: jsonEncode([
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
  RemoteConfigServiceKeys.miutemDescripcion:
      "Esta aplicación surgió a principios del 2019 como un proyecto independiente **creado completamente por estudiantes** del Club de Desarrollo Experimental (ExDev) de la UTEM ❤️.  \nActualmente nos encontramos trabajando **junto al equipo de SISEI** para que esta aplicación se convierta en la aplicación institucional oficial de la universidad 🎉  \nToda la información corresponde a datos referenciales, y debe ser validada por la Dirección General de Docencia.",
  RemoteConfigServiceKeys.miutemPortada:
      "https://user-images.githubusercontent.com/16374322/114324046-16cb8100-9af6-11eb-9a95-11da425e2fbd.png",
  RemoteConfigServiceKeys.miutemDesarrolladores: jsonEncode([
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
  RemoteConfigServiceKeys.credencialBarras:
      "Código de barras compatible con Sistema de Bibliotecas",
  RemoteConfigServiceKeys.credencialInfo:
      "**Mayor información:** \n\n [biblioteca.utem.cl](https://biblioteca.utem.cl/)\n\nEn caso de dudas con su credencial, consultar a su biblioteca o al correo electrónico [**credenciales@utem.cl**](mailto:credenciales@utem.cl)",
  RemoteConfigServiceKeys.credencialDisclaimer:
      "**Esta credencial virtual es generada automáticamente y es de uso personal e intransferible. El atraso en la devolución de libros y revistas será sancionado por la biblioteca.**",
  RemoteConfigServiceKeys.credencialSibutemLogo:
      "https://user-images.githubusercontent.com/16374322/114325090-42ea0080-9afc-11eb-9cc8-ef4846d4ad8f.jpg",
  RemoteConfigServiceKeys.calculadoraMostrar: true,
  RemoteConfigServiceKeys.horarioZoom: 0.5,
  RemoteConfigServiceKeys.homeProntoIcono: Icons.pregnant_woman.codePoint,
  RemoteConfigServiceKeys.homeProntoTexto:
      "Se están gestando nuevas funciones 😎",
  RemoteConfigServiceKeys.prontoEg: "Este recurso no esta disponible",
  RemoteConfigServiceKeys.egHabilitados: true,
  RemoteConfigServiceKeys.drawerMenu: jsonEncode([
    {
      "title": "Perfil",
      "icon": {
        "codePoint": Icons.person.codePoint,
        "fontFamily": 'MaterialIcons'
      },
      "route": Routes.perfil,
      "show": true,
    },
    {
      "title": "Asignaturas",
      "icon": {
        "codePoint": Icons.book.codePoint,
        "fontFamily": 'MaterialIcons'
      },
      "route": Routes.asignaturas,
      "show": true,
    },
    {
      "title": "Horario",
      "icon": {
        "codePoint": Mdi.clockTimeEight.codePoint,
        "fontFamily": 'Material Design Icons',
        "fontPackage": "mdi"
      },
      "route": Routes.horario,
      "show": true
    },
    {
      "title": "Credencial",
      "icon": {
        "codePoint": Mdi.cardAccountDetails.codePoint,
        "fontFamily": 'Material Design Icons',
        "fontPackage": "mdi"
      },
      "show": true,
      "route": Routes.credencial,
      "requiredRoles": ["hasActiveCareer"],
      "badge": "Nuevo"
    },
  ]),
  RemoteConfigServiceKeys.greetings: jsonEncode(['Que gusto verte, **%name**']),
  RemoteConfigServiceKeys.quickMenu: jsonEncode([
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
