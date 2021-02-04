import 'package:flutter/material.dart';
import 'package:heroserviceapp/screens/bottomnav/booking_screen.dart';
import 'package:heroserviceapp/screens/bottomnav/home_screen.dart';
import 'package:heroserviceapp/screens/bottomnav/market_screen.dart';
import 'package:heroserviceapp/screens/bottomnav/setting_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // สร้างตัวแปรแบบ List ไว้เก็บรายการของ Tab Bottom
  int _currentIndex = 0;
  String _title = 'Hero Service';

  final List<Widget> _children = [
    HomeScreen(),
    MarketScreen(),
    BookingScreen(),
    SettingScreen(),
  ];

  // สร้างฟังก์ชั่นเพื่อใช้ในการเปลี่ยนหน้า
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      print(index);

      // เปลี่ยน title ไปตาม tab ที่เลือก
      switch (index) {
        case 0:
          _title = 'บริการ';
          break;
        case 1:
          _title = 'ตลาด';
          break;
        case 2:
          _title = 'รายการจอง';
          break;
        case 3:
          _title = 'อื่นๆ';
          break;
        // default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(_title)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.business_center), label: 'บริการ'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'ตลาด'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: 'รายการจอง'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'อื่นๆ'),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.teal,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
      ),
      body: _children[_currentIndex],
    );
  }
}
