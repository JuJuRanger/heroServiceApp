import 'package:flutter/material.dart';
import 'package:heroserviceapp/screens/qrcode/mycode_screen.dart';
import 'package:heroserviceapp/screens/qrcode/scanner_screen.dart';

class QRcodeScreen extends StatefulWidget {
  QRcodeScreen({Key key}) : super(key: key);

  @override
  _QRcodeScreenState createState() => _QRcodeScreenState();
}

class _QRcodeScreenState extends State<QRcodeScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    // length คือจำนวน tap  ## มี 2 tab ##
    // vsync จะใช้ this แต่ตรง this มันจะ error  ให้ใส่ SingleTickerProviderStateMixin
    // this มันเหมือนถึง class _QRcodeScreenState นะครับ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('คิวอาร์โค้ด'),
        // TabBar คือ สร้าง menu บน tab นะครับ
        bottom: TabBar(
          controller: controller,
          tabs: [
            Tab(text: 'ตัวสแกน'),
            Tab(text: 'โค้ดของฉัน'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          ScannerScreen(),
          MyCodeScreen(),
        ],
      ),
    );
  }
}
