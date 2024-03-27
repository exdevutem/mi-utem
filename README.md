# Mi UTEM para Android e iOS
Aplicación multiplataforma hecha por estudiantes de la [Universidad Tecnológica Metropolitana de Chile](https://www.utem.cl/) enfocada en adaptar la [plataforma académica Mi.UTEM](https://mi.utem.cl/) de la institución a dispositivos móviles.

## Requisitos técnicos
- Flutter 3.13.6

## Organización de carpetas
```
|-- lib
|   |-- config (Configuración de la aplicación)
|   |-- controllers (Controladores de la aplicación, para procesar datos de una vista especifica)
|   |   |-- implementations (Implementaciones de controladores)
|   |   |-- interfaces (Interfaces de controladores)
|   |-- models (Modelos de datos)
|   |-- repositories (Repositorios de datos, para obtener datos desde la API)
|   |   |-- implementations (Implementaciones de repositorios)
|   |   |-- interfaces (Interfaces de repositorios)
|   |-- screens (Pantallas de la aplicación)
|   |-- services (Servicios de la aplicación, maneja y procesa los datos de repositorios)
|   |   |-- implementations (Implementaciones de servicios)
|   |   |-- interfaces (Interfaces de servicios)
|   |-- themes (Temas de la aplicación)
|   |-- utils (Utilidades de la aplicación)
|   |-- widgets (Widgets de la aplicación)
|-- main.dart (Punto de entrada de la aplicación)
```

## Créditos
Este proyecto fue creado por el Club de Desarrollo Experimental (ExDev) de la Universidad Tecnológica Metropolitana y es mantenido por los propios estudiantes con el apoyo del equipo de SISEI. Mira los perfiles que han contribuido a este proyecto:

<a href="https://github.com/exdevutem/mi-utem/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=exdevutem/mi-utem" alt="Contribuidores"/>
</a>