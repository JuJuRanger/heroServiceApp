import 'package:flutter/material.dart';
import 'package:heroserviceapp/screens/dashboard/dashboard_screen.dart';
import 'package:heroserviceapp/screens/lockscreen/lock_screen.dart';
import 'package:heroserviceapp/screens/welcome/welcome_screen.dart';

// สร้างตัวแปร Map ไว้เก็บ URL : Screen เป็น array
final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/welcome': (BuildContext context) => WelcomeScreen(),
  '/dashboard': (BuildContext context) => DashboardScreen(),
  '/lockscreen': (BuildContext context) => LockScreen(),
};
