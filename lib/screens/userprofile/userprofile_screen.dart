import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heroserviceapp/models/LoginModel.dart';
import 'package:heroserviceapp/services/rest_api.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({Key key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  //เรียกใช้งานตัวแปร SharedPreference
  SharedPreferences sharedPreferences;

  // เรียกใช้งานตัว LoginModel มาเก็บลงใน _dataProfile
  LoginModel
      _dataProfile; // ถ้ามองคล้ายกับเป็นโครงสร้าง เพื่อเอา value ที่เรียกมา ใส่ลงในโครงสร้าง

  String _birthDate;

  // การ Call api การอ่าน api User Profile
  readUserProfile() async {
    // เช็คว่าเครื่องผู้ใช้ Online หรือ Offline
    var isOnline = await Connectivity().checkConnectivity();
    // ถ้า Offline อยู่
    if (isOnline == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "คุณไม่ได้เชื่อมต่ออินเตอร์เนต",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      // อ่านข้อมูลจาก SharePreference
      sharedPreferences = await SharedPreferences.getInstance();

      var userData = {
        "email": sharedPreferences.getString('storeEmail'),
        // "email": sharedPreferences.getString('storeEmail').toString(),
        "password": sharedPreferences.getString('storePassword'),
      };
      try {
        var response = await CallAPI().getUserProfile(userData);
        print(response); // Instance of 'LoginModel'
        print(response.data.firstname);

        setState(() {
          _dataProfile = response; // โครงสร้าง Model = ข้อมูลที่เรียกจาก api
          _birthDate = DateFormat('dd-MM-yyyy').format(_dataProfile?.data?.birthdate);
        });

        /* 
        {
          "code": "200",
          "status": "success",
          "message": "Login success",
          "data": {
              "id": "3",
              "empid": "7777777",
              "cizid": "3770400404433",
              "imei": "956895487",
              "passcode": "256986",
              "prename": "นาย",
              "firstname": "สามิตร",
              "lastname": "โกยม",
              "email": "samit@gmail.com",
              "password": "96e79218965eb72c92a549dd5a330112",
              "tel": "089389038033",
              "address": "3/25 บางใหญ่ นนทบุรี 10250",
              "gender": "ชาย",
              "position": "เจ้าหน้าที่ปฎิบัติการ",
              "department": "ไอที",
              "salary": "28000.00",
              "birthdate": "2020-09-08",
              "avatar": "https://www.itgenius.co.th/backend/assets/images/user_avatar/gsb8hg5j5qyh98fefujthj3kct4uteqz.jpg",
              "status": "1"
          }
        }
         */
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    readUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลผู้ใช้'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('ชื่อ - สกุล'),
            subtitle: Text('${_dataProfile?.data?.firstname ?? "..."}'), // อย่าลืม setstage _dataProfile
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('รหัสผู้ใช้'),
            subtitle: Text('${_dataProfile?.data?.empid ?? "..."}'),
          ),
          ListTile(
            leading: Icon(Icons.person_pin),
            title: Text('เพศ'),
            subtitle: Text('${_dataProfile?.data?.gender ?? "..."}'),
          ),
          ListTile(
            leading: Icon(Icons.person_pin_circle),
            title: Text('ตำแหน่ง'),
            subtitle: Text('${_dataProfile?.data?.position ?? "..."}'),
          ),
          ListTile(
            leading: Icon(Icons.person_pin_circle),
            title: Text('สังกัด'),
            subtitle: Text('${_dataProfile?.data?.department ?? "..."}'),
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('เงินเดือน'),
            subtitle: Text('${_dataProfile?.data?.salary ?? "..."}'),
          ),
          ListTile(
            leading: Icon(Icons.cake),
            title: Text('วัดเกิด'),
            subtitle: Text('${_birthDate ?? "..."}'),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('อีเมล์'),
            subtitle: Text('${_dataProfile?.data?.email ?? "..."}'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('โทรศัพท์'),
            subtitle: Text('${_dataProfile?.data?.tel ?? "..."}'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('ที่อยู่'),
            subtitle: Text('${_dataProfile?.data?.address ?? "..."}'),
          ),
        ],
      ),
    );
  }
}
