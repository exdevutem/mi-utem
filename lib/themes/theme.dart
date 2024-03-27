import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainTheme {
  static Color get utemAzul => Color(0xff06607a);
  static Color get utemVerde => Color(0xff1d8e5c);

  static Color get primaryColor => Color(0xFF009d9b);
  static Color get primaryLightColor => Color(0xFF45bbbc);
  static Color get primaryDarkColor => Color(0xFF007f7b);
  static Color? get disabledColor => Colors.grey[400];

  static Color get inscritoColor => Color(0xff021A8E);
  static Color get reprobadoColor => Color(0xffF55753);
  static Color get aprobadoColor => Color(0xff2DD69C);

  static const Color darkGrey = Color(0xff363636);
  static const Color grey = Color(0xff7f7f7f);
  static const Color mediumGrey = Color(0xFFBDBDBD);
  static const Color lightGrey = Color(0xfff1f1f1);

  static const Color dividerColor = mediumGrey;

  static double elevation = 0;

  static ThemeData get theme => ThemeData(
    useMaterial3: false, // Cuando podamos hay que migrar a material 3.
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      disabledElevation: 0,
      elevation: 0,
    ),
    tabBarTheme: TabBarTheme(indicatorSize: TabBarIndicatorSize.tab),
    disabledColor: disabledColor,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.resolveWith((states) => states.any({MaterialState.disabled}.contains) ? disabledColor : primaryColor),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          StadiumBorder(),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.resolveWith((states) => states.any({MaterialState.disabled}.contains) ? BorderSide(color: disabledColor!) : BorderSide(color: primaryColor)),
        foregroundColor: MaterialStateProperty.resolveWith((states) => states.any({MaterialState.disabled}.contains) ? disabledColor : primaryColor),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 5, horizontal: 20)),
        shape: MaterialStateProperty.all(
          StadiumBorder(
            side: BorderSide(width: 3),
          ),
        ),
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      textTheme: ButtonTextTheme.normal,
      disabledColor: disabledColor,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.grey,
          width: 0.3,
          style: BorderStyle.solid,
        ),
      ),
    ),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      color: primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      isDense: true,
      hintStyle: TextStyle(color: Colors.grey[400]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
    ),
    primaryColor: primaryColor,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: primaryLightColor,
      onSecondary: primaryDarkColor,
      error: reprobadoColor,
      onError: Colors.white,
      background: lightGrey,
      onBackground: darkGrey,
      surface: lightGrey,
      onSurface: darkGrey,
    ),
  );

  static TextTheme get textTheme => TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 36,
          color: darkGrey,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: darkGrey,
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26,
          color: darkGrey,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkGrey,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: grey,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          color: grey,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
          color: darkGrey,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          color: grey,
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          color: darkGrey,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: grey,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      );
}

class HorarioText extends Text {
  HorarioText._(
    String text, {
    Key? key,
    required TextAlign textAlign,
    required Color color,
    int? maxLines,
    required bool bold,
    double? wordSpacing,
    double? letterSpacing,
  }) : super(
          text,
          key: key,
          maxLines: maxLines,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: 18,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color,
            wordSpacing: wordSpacing,
            letterSpacing: letterSpacing,
          ),
        );

  factory HorarioText.classCode(
    String text, {
    Color color = Colors.white,
    TextAlign textAlign = TextAlign.center,
  }) =>
      HorarioText._(
        text,
        bold: false,
        color: color,
        textAlign: textAlign,
      );

  factory HorarioText.className(
    String text, {
    Color color = Colors.white,
    TextAlign textAlign = TextAlign.center,
  }) =>
      HorarioText._(
        text,
        maxLines: 3,
        bold: true,
        letterSpacing: 0.5,
        wordSpacing: 1,
        color: color,
        textAlign: textAlign,
      );

  factory HorarioText.classLocation(
    String text, {
    Color color = Colors.white,
    TextAlign textAlign = TextAlign.center,
  }) =>
      HorarioText._(
        text,
        maxLines: 2,
        bold: false,
        color: color,
        textAlign: textAlign,
      );
}
