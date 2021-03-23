import 'package:flutter/material.dart';
import 'package:heroserviceapp/routes.dart';
import 'package:heroserviceapp/themes/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

var appStep; // ไว้ดึง step จาก shareprefenceว่าอยู่ step เท่าไหร่
var initURL; // จะคอยกำหนด URL ว่าจะ step ไหน ก็ให้ไปหน้านั้น

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ถ้า main มันมี async ให้ใส่บรรทัดนี้ด้วย
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  appStep = sharedPreferences.getInt('appStep');

  if (appStep == 1) {
    initURL = '/login';
  } else if (appStep == 2) {
    initURL = '/dashboard';
  } else if (appStep == 3) {
    initURL = '/lockscreen';
  } else {
    initURL = '/welcome';
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: appTheme(),
      routes: routes, // เรียกตัวแปร routes หน้า lib/routes.dart
      initialRoute: initURL,
    );
  }
}
