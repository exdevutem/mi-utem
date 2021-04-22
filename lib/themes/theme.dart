import 'package:flutter/material.dart';

class MainTheme {
  static Color get utemAzul => Color(0xff06607a);
  static Color get utemVerde => Color(0xff1d8e5c);

  static Color get primaryColor => Color(0xFF009d9b);
  static Color get primaryLightColor => Color(0xFF45bbbc);
  static Color get primaryDarkColor => Color(0xFF007f7b);
  static Color get disabledColor => Colors.grey[400];

  static Color get inscritoColor => Color(0xff021A8E);
  static Color get reprobadoColor => Color(0xffF55753);
  static Color get aprobadoColor => Color(0xff2DD69C);

  static const Color darkGrey = Color(0xff363636);
  static const Color grey = Color(0xff7f7f7f);
  static const Color lightGrey = Color(0xfff1f1f1);

  static double elevation = 0;

  static ThemeData get theme => ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      disabledElevation: 0,
      elevation: 0,
    ),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab
    ),
    disabledColor: disabledColor,
    
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
        )
      ),
    ),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      color: primaryColor,
      
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      isDense: true,
      hintStyle: TextStyle(color: Colors.grey[400]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      )
    ),
    primaryColor: primaryColor,
    accentColor: primaryLightColor,
  );

  static TextTheme get textTheme => TextTheme(
        headline1: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 32,
          color: darkGrey,
        ),
        headline2: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: darkGrey,
        ),
        headline3: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: darkGrey,
        ),
        headline4: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: darkGrey,
        ),
        headline5: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: grey,
        ),
        headline6: TextStyle(
          fontSize: 18,
          color: grey,
        ),
        subtitle1: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: darkGrey,
        ),
        subtitle2: TextStyle(
          fontSize: 16,
          color: grey,
        ),
        button: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
        bodyText1: TextStyle(
          color: darkGrey,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyText2: TextStyle(
          color: grey,
          fontSize: 16,
        ),
      );
}