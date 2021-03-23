import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // สร้างตัวแปรไว้เก็บชื่อ และรูปโปรไฟล์
  String _fullname, _avartar;
  // สร้าง Object Sharepreference
  SharedPreferences sharedPreferences;
  // อ่านข้อมูลผู้ใช้จาก api ด้วย Sharepreference
  getProflie() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _fullname = sharedPreferences.getString('storeFullname');
      _avartar = sharedPreferences.getString('storeAvatar');
    });
  }
  // ฟังชั่นเช็คการเชื่อมต่อ network
  checkNetwork() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi) {
      /* 
        ConnectivityResult.mobile = เชื่อมต่อเนตมือถืออยู่
        ConnectivityResult.wifi = ต่อแบบ wifi
        ConnectivityResult.none = ไม่ได้ต่อ internet ไว้ offline
        ConnectivityResult.value = เราสามารถใส่คำเข้าไปได้ เช่น 5g ใส่ value keyword
       */
      Fluttertoast.showToast(
        msg: "คุณกำลังเชื่อมต่อผ่าน Wifi",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (result == ConnectivityResult.mobile) {
      Fluttertoast.showToast(
        msg: "คุณกำลังเชื่อมต่อผ่าน 4G",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (result == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "คุณไม่ได้เชื่อมต่ออินเตอร์เนต",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


  // ฟังชั่นตอนเริ่มโหลดหน้าของแอพ
  @override
  void initState() {
    super.initState();
    getProflie();
    checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    // getProflie(); // ลองเรียก method ตรงนี้ก็มานะ แต่อาจารย์เรียก initState()

    return Scaffold(
        body: ListView(
      children: [
        Container(
          width: double.infinity,
          height: 250.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/imageinternet.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: _avartar == null ? CircularProgressIndicator() : CircleAvatar(
                  radius: 45,
                  // backgroundImage: AssetImage('assets/images/logo_private.jpg'),
                  backgroundImage: NetworkImage('$_avartar'),
                  /* ติดปัญหา null ก่อนขึ้นภาพ */
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$_fullname',
                style: TextStyle(fontSize: 24, color: Colors.white, shadows: [
                  Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 1.0,
                      color: Colors.yellow),
                ]),
              )
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('ข้อมูลผู้ใช้'),
          onTap: () {
            Navigator.pushNamed(context, '/userprofile');
          }, // icon
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('เปลี่ยนรหัสผ่าน'),
          onTap: () {}, // icon
        ),
        ListTile(
          leading: Icon(Icons.language),
          title: Text('เปลี่ยนภาษา'),
          onTap: () {}, // icon
        ),
        ListTile(
          leading: Icon(Icons.email),
          title: Text('ติดต่อทีมงาน'),
          onTap: () {}, // icon
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('ตั้งค่าใช้งาน'),
          onTap: () {}, // icon
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('ออกจากระบบ'),
          onTap: () async {
            // สร้าง Object แบบ Sharedpreference
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            // เก็บค่าลงตัวแปรแบบ Sharedpreferences
            sharedPreferences.setInt('appStep', 3);
            Navigator.pushReplacementNamed(context, '/lockscreen');
          }, // icon
        ),
      ],
    ));
  }
}
