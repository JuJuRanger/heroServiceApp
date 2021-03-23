import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:heroserviceapp/screens/bottomnav/booking_screen.dart';
import 'package:heroserviceapp/screens/bottomnav/home_screen.dart';
import 'package:heroserviceapp/screens/bottomnav/market_screen.dart';
import 'package:heroserviceapp/screens/bottomnav/notification_screen.dart';
import 'package:heroserviceapp/screens/bottomnav/setting_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // สร้างตัวแปรแบบ List ไว้เก็บรายการของ Tab Bottom
  int _currentIndex = 2;
  String _title = 'Hero Service';
  Widget _actionWidget;

  final List<Widget> _children = [
    MarketScreen(),
    BookingScreen(),
    HomeScreen(),
    NotificationScreen(),
    SettingScreen(),
  ];

  // สร้าง Widget action สำหรับแยก Icon Appbar แต่ละหน้า
  Widget _homeAppbarAction() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/qrcode');
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Row(
          children: [
            Icon(Icons.center_focus_strong),
            Text('SCAN'),
          ],
        ),
      ),
    );
  }

  Widget _marketAppbarAction() {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Row(
          children: [
            Icon(Icons.add),
            Text('Add News'),
          ],
        ),
      ),
    );
  }

  // สร้างฟังก์ชั่นเพื่อใช้ในการเปลี่ยนหน้า
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      // print(index);

      // เปลี่ยน title ไปตาม tab ที่เลือก
      switch (index) {
        case 0:
          _title = 'ตลาด';
          _actionWidget = _marketAppbarAction();
          break;
        case 1:
          _title = 'รายการจอง';
          _actionWidget = Container(); // กล่องเปล่า
          break;
        case 2:
          _title = 'หน้าหลัก';
          _actionWidget = _homeAppbarAction();
          break;
        case 3:
          _title = 'แจ้งเตือน';
          _actionWidget = Container();
          break;
        case 4:
          _title = 'อื่นๆ';
          _actionWidget = Container();
          break;
        // default:
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _actionWidget = _homeAppbarAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [_actionWidget],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: onTabTapped,
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.business_center), label: 'บริการ'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.shopping_cart), label: 'ตลาด'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.library_books), label: 'รายการจอง'),
      //     BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'อื่นๆ'),
      //   ],
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.teal,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.white,
      // ),

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.teal,
        buttonBackgroundColor: Colors.teal,
        height: 60,
        animationDuration: Duration(milliseconds: 200),
        index: 2,
        animationCurve: Curves.bounceInOut,
        items: [
          Icon(
            Icons.shopping_basket,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.library_books,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.business_center,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.notifications,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.menu,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: onTabTapped,
      ),
      body: _children[_currentIndex],
    );
  }
}
