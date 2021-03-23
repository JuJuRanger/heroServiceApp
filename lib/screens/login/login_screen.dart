import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heroserviceapp/screens/components/passwordwidget.dart';
import 'package:heroserviceapp/services/rest_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // กำหนดตัวแปรสำหรับเก็บอีเมล์และรหัสผ่าน
  String _email, _password;

  // สร้างคีย์สำหรับเก็บสถานะของฟอร์ม /* Flutter Advance Day 3 time 41:40 */
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: GestureDetector(
        //  GestureDetector มีประโยชน์คือ เมื่อแป้นคีย์บอร์ดมาทำ สามารถให้ฟอร์มเลื่อนได้
        // และ
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20, color: Colors.teal),
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'กรอกอีเมล์',
                  ),
                  // maxLength: 5,
                  // initialValue: 'samit@gmail.com',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'กรุณากรอกอีเมล์ก่อน';
                    } else {
                      return null;
                    }
                  },
                  onFieldSubmitted: (value) {
                    setState(() {
                      this._email = value;
                    });
                  },
                  onSaved: (newValue) {
                    this._email = newValue.trim();
                  },
                ),
                PasswordField(
                  helperText: 'ไม่เกิน 6 หลัก',
                  labelText: 'กำหนดรหัสผ่าน',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'กรุณากรอกรหัสผ่านก่อน';
                    } else if (value.length != 6) {
                      return 'กรุณาป้อนรหัสผ่านด้วยเลข 6 หลัก';
                    } else {
                      return null;
                    }
                  },
                  onFieldSubmitted: (value) {
                    setState(() {
                      this._password = value;
                    });
                  },
                  onSaved: (newValue) {
                    this._password = newValue.trim();
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      // print(_email);
                      // print(_password);
                      var userData = {
                        "email": _email,
                        "password": _password,
                      };
                      _loginProcess(userData);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                  color: Colors.green,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชั่นเช็คการล็อคอิน
  void _loginProcess(userData) async {
    try {
      var response = await CallAPI().loginAPI(userData);
      var body = json.decode(response.body);
      print(body['message']);

      // เช็คว่าถ้าลงทะเบียนสำเร็จ
      if (body['status'] == 'success' && body['data']['status'] == '1') {
        // สร้าง Object แบบ Sharedpreference
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        // เก็บค่าลงตัวแปรแบบ Sharedpreferences
        sharedPreferences.setInt('appStep', 2);
        sharedPreferences.setString(
            'storeFullname',
            body['data']['prename'] +
                body['data']['firstname'] +
                ' ' +
                body['data']['lastname']);
        sharedPreferences.setString('storeAvatar', body['data']['avatar']);
        // ไม่ security ควรแยกไปอีก url นึง แต่ทำให้ดูเป็นตัวอย่าง
        sharedPreferences.setString('storeEmail', _email);
        sharedPreferences.setString('storePassword', _password);

        // ส่งไปหน้า dashborad
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        _showDialog('มีข้อผิดพลาด', 'ข้อมูลไม่ถูกต้อง ลองใหม่อีกครั้ง');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "มีข้อผิดพลาดการโหลดข้อมูล",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _showDialog(title, msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close')),
            ],
          );
        });
  }
}
