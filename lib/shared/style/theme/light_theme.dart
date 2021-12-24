import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';

ThemeData light_theme = ThemeData(
    primarySwatch: MainColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0.0,
        backwardsCompatibility: false,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actionsIconTheme: IconThemeData(
            color: Colors.black
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark
        )
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: MainColor,
        elevation: 20.0,
        backgroundColor: Colors.white
    ),
    textTheme: const TextTheme(
        bodyText1: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black
        )
    ),
    fontFamily: 'Roboto-Regular'
);