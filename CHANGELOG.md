# Changelog

Todos los cambios a este proyecto se documentarán en este archivo

Este formato esta basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto se adhiere al [Versionado Semántico](https://semver.org/spec/v2.0.0.html).

Directrices

- Están hechos para los seres humanos, no para las máquinas.
- Debe haber una entrada para cada versión.
- Los mismos tipos de cambios deben ser agrupados.
- Versiones y secciones deben ser enlazables.
- La última versión va primero.
- Debe mostrar la fecha de publicación de cada versión.
- Indicar si el proyecto sigue el Versionamiento Semántico.
- Los cambios no deben tener un lenguaje técnico y deben ser entendidos por cualquier usuario.
- Se documentará en español.

Tipos de cambios

- `Added`: para funcionalidades nuevas.
- `Changed`: para los cambios en las funcionalidades existentes.
- `Deprecated`: para indicar que una característica o funcionalidad está obsoleta y que se eliminará en las próximas versiones.
- `Removed`: para las características en desuso que se eliminaron en esta versión.
- `Fixed`: para corrección de errores.
- `Security`: en caso de vulnerabilidades.

## [Unreleased]

### Changed

- Se eliminó el anuncio de 'gestando nuevas funciones'. La señora vivirá siempre en nuestros corazones.
- Mejora en el caché de los pérmisos QR

### Fixed

- Ya no se desloggeará a los usuarios erroneamente

## [2.11.4] 2023-04-13Z

### Added

- Integración con UXCam
- Más eventos de analytics

### Changed

- Ahora el controlador del horario es permanente
- Nuevo diseño para la pantalla del resumen de asignatura
## [2.11.2] - 2023-04-06

Esta versión del changelog contiene cambios hechos en 2.10, debido a que no se documentaron!

### Added

- Calculadora de notas
- Indicador en pantalla de Horario
- Integración con Awesome Notifications y Background fetch.

### Fixed

- Comportamientos de scroll y zoom en horario
- Capturas de pantalla en horario
- Configuración de iOS para horario
- Correcciones varias de Horario
- Errores cuando el usuario no tiene las notas guardadas
- Errores de Fastline.

## [2.9.0] - 2023-01-15Z

### Added

- Pantalla de horario cuenta con colores aleatorios por asignatura guardados en caché

### Fixed

- Ahora soporta todos los estados de carrera

## [2.8.4] - 2022-05-30Z

### Added

- Nuevo archivo CHANGELOG para documentar los cambios de cada versión
- Sección con lista de permisos de ingreso del usuario en la pantalla principal
- Pantalla con información detallada y codigo QR para los permisos de ingreso
- Posibilidad de ver en pantalla completa el código QR de los permisos de ingreso
- Nuevo saludo dinámico en la pantalla de inicio

### Fixed

- Arreglado el código de barras en la credencial para estudiantes con RUT 20 millones para arriba
- Notas y ponderadores funcionando nuevamente

### Changed

- Ahora las consultas al servidor se guardan en el caché del teléfono

## [2.7.3] - 2022-03-27Z

### Fixed

- Tiempos de respuesta, ahora más cortos

### Removed

- Lista de estudiantes en la pantalla de asignatura
- Perfil de profesores
- Perfil de profesores
- Perfil de profesores
