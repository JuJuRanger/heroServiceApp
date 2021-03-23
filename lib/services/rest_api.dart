import 'dart:convert';

import 'package:heroserviceapp/models/LoginModel.dart';
import 'package:heroserviceapp/models/NewDetailModel.dart';
import 'package:heroserviceapp/models/NewsModel.dart';
import 'package:http/http.dart' as http;

class CallAPI {
  _setHeaders() => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  final String baseAPIURL =
      'https://www.itgenius.co.th/sandbox_api/flutteradvapi/public/api/';

  // Login API
  loginAPI(data) async {
    return await http.post(
      baseAPIURL + 'login',
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // Flutter advance Day 5 time 25:10
  // Read User Profile
  /* การโหลด Model แบบ Single */
  /* 
      ต้องอาศัย Model มาประกอบด้วยนะครับ จากไฟล์ที่ชื่อว่า LoginModel.dart
      LoginModel เราทำมาจาก quicktype.io มันจะทำการแปลงจาก json -> dart ให้
      json ตัวอย่างนี้ยังง่าย เพราะเป็น key : value ของข้อมูลคนเดียว
      เน้น แต่ต้องทำผ่าน Model เสมอ !! เมื่อไหร่เป็น json มาต้องทำผ่าน Model
      การแปลงมันจะคล้ายกันกับลักษณะเป็น [array][array]

      ณ ตอนนี้ api เราพร้อมแล้ว
      เราทำการ Read User Profile 
      วิธีการ Read เราจะทำผ่าน type Future
   */
  // Future คือ ข้อมูลที่มันจะมีการรอคอยการโหลดมาจาก Backend
  // เป็นการอ่าน Read ข้อมูลอยู่ที่ Background และทำการส่งกลับมาเมื่อมันอ่านเสร็จ
  // เราจะประกาศมันข้างหน้า Future
  /*  
      ข้อมูลที่ผ่าน api มันต้องทำผ่าน Future นะครับ
      Future จริงๆ ข้อมูลมันอาจจะโหลดยังไม่เสร็จ แล้วมันอาจจะมีการตอบกลับมาหลังจากมันโหลดเสร็จแล้วนะครับ !!
      ฉะนั้น เราจะสร้าง method ที่ชื่อว่า getUserProfile
   */

  // พอมันเป็น Future ใน Future เราต้องมีการส่ง Model เข้าไป
  // เพราะว่าตัว Future มันจะ Return ค่ากลับมาเป็น callback function
  // callback คือเมื่อมันเสร็จแล้วมันจะมีการ return กลับมาจากฝั่ง api ว่าอะไรนั่นเองครับ
  // และ Future มันควรเป็นแบบ async await ด้วยนะครับ
  // ที่นี้เวลาเรายิงข้อมูลไป เราต้องมีการส่ง data เข้าไปใน getUserProfile(data) ด้วยนะครับ
  // data คือ {"email":"samit@gmail.com","password":"111111"} (เหมือนแนบของใน postman method post)
  // จากนั้นเราสร้างเราแปลมาเพื่อรับค่าที่ส่งกลับมา ตัวแปรที่รับชื่อว่า response
  // จะคล้ายกับข้างบน แต่ข้างล่างมี Model มาเกี่ยวข้องด้วย
/* type <Model>  */
  Future<LoginModel> getUserProfile(data) async {
    final response = await http.post(
      baseAPIURL + 'login',
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
    // เช็คว่าค่าที่ส่งกลับมามีค่า status อะไร
    if (response.statusCode == 200) {
      // ที่ Model มันจะมีสิ้่งนี้อยู่ loginModelFromJson เราจะ Return ตัวนี้ออกไป
      // ทุก Model ที่เราสร้างไว้ มันจะมี Method ข้างบนสุดว่า FormJson ตัวนี้คือ ทำการ Read ตัว Json ออกไป
      return loginModelFromJson(response.body);
    } else {
      // ไม่ใช่ให้เป็น null เราสามารถเอาไปเช็คอย่างอื่นได้ถ้าไม่ใช่ status 200 ให้ออกค่าเป็น null
      return null;
    }
  }

  // Read Last News Model
  Future<List<NewsModel>> getLastNews() async {
    final response = await http.get(
      baseAPIURL + 'lastnews',
      headers: _setHeaders(),
    );
    if (response.body != null) {
      return newsModelFromJson(response.body);
    } else {
      return null;
    }
  }

  // Read All News Model
  Future<List<NewsModel>> getAllNews() async {
    final response = await http.get(
      baseAPIURL + 'news',
      headers: _setHeaders(),
    );
    if (response.body != null) {
      return newsModelFromJson(response.body);
    } else {
      return null;
    }
  }

  // Read News Detail By ID
  Future<NewsDetailModel> getNewsDetail(id) async {
    final response = await http.get(
      baseAPIURL + 'news/' + id,
      headers: _setHeaders(),
    );
    if (response.body != null) {
      return newsDetailModelFromJson(response.body);
    } else {
      return null;
    }
  }


}
