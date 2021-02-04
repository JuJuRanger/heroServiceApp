import 'package:flutter/material.dart';

ThemeData appTheme(){
  return ThemeData(
    fontFamily: 'Montserrat', // เอามาจาก font family => pubspec.yaml
    primaryColor: Colors.blue, // สีตรง hearder screen
    accentColor: Colors.blueAccent, // สีตรง status bar เข้มๆ
    buttonColor: Colors.lightBlue, // สีปุ่มกด
  );
}