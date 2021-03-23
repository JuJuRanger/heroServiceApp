import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:rxdart/rxdart.dart';

class ScannerScreen extends StatefulWidget {
  ScannerScreen({Key key}) : super(key: key);

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  // สร้าง Object สำหรับเรียกตัวสแกน QR
  QRViewController _controller;
  GlobalKey _globalKey = GlobalKey();
  bool _flashOn = false;
  bool _frontCam = false;

  File _image;
  String _data = "";
  String _qrcodeFile = "";

  // Step 1 การนำรูปจาก gallery นำเข้ามาได้รับ filepath
  // สร้าง function method สำหรับการเลือกรูปจาก gallery
  Future getImage() async {
    // image ที่สร้างคือ ทำ File path นะ (File: '/storage/emulated/0/DCIM/Camera/IMG_00001.jpg)
    var image = await ImagePickerSaver.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      Fluttertoast.showToast(
        msg: _image.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    String filename = '1559788943.png';
    Observable.fromFuture(getTemporaryDirectory())
        .flatMap((tempDir) {
          File qrCodeFile = File('${tempDir.path}/$filename');
          bool exists = qrCodeFile.existsSync();
          if (exists) {
            return Observable.just(qrCodeFile);
          } else {
            return Observable.fromFuture(
                    rootBundle.load("assets/images/$filename"))
                .flatMap((bytes) => Observable.fromFuture(
                    qrCodeFile.writeAsBytes(bytes.buffer.asUint8List(
                        bytes.offsetInBytes, bytes.lengthInBytes))));
          }
        })
        .flatMap((file) =>
            Observable.fromFuture(QrCodeToolsPlugin.decodeFrom(file.path)))
        .listen((data) {
          setState(() {
            _data = data;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        QRView(
          key: _globalKey,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.white,
            borderLength: 15.0, // ความยาวเส้น
            borderWidth: 5.0,
            borderRadius: 4,
          ),
          onQRViewCreated: (_controller) {
            this._controller = _controller;
            // รับค่ามาใช้งานจากการ Scan
            _controller.scannedDataStream.listen((val) {
              print(val);
              if (mounted) {
                // mounted คือ ถ้ามันทำการสแกนเสร็จแล้ว
                Fluttertoast.showToast(
                  msg: val,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                // หยุดการทำงาน kill process
                _controller.dispose();
                // ปิดหน้าสแกน
                Navigator.pop(context);
              } else {}
            });
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 60.0),
            child: Text(
              'วางคิวอาร์โค้ดให้อยู่ในกรอบเพื่อสแกน',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 100.0),
            child: OutlineButton(
              onPressed: _getPhotoByGallery,
              // onPressed: () {
              //   getImage();
              // },
              child: Text(
                'นำเข้าจากแกลอรี่',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              borderSide: BorderSide(color: Colors.white),
              shape: StadiumBorder(), // ขอบมล 4 ด้าน
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  color: Colors.white,
                  icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
                  onPressed: () {
                    setState(() {
                      _flashOn = !_flashOn;
                      _controller.toggleFlash();
                    });
                  },
                ),
                IconButton(
                  color: Colors.white,
                  icon:
                      Icon(_frontCam ? Icons.camera_front : Icons.camera_rear),
                  onPressed: () {
                    setState(() {
                      _frontCam = !_frontCam;
                      _controller.flipCamera();
                    });
                  },
                ),
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _getPhotoByGallery() {
    Observable.fromFuture(
            ImagePickerSaver.pickImage(source: ImageSource.gallery))
        .flatMap((file) {
      setState(() {
        _qrcodeFile = file.path;
      });
      return Observable.fromFuture(QrCodeToolsPlugin.decodeFrom(file.path));
    }).listen((data) {
      setState(() {
        _data = data;
        Fluttertoast.showToast(
          msg: data.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    }).onError((error, stackTrace) {
      setState(() {
        _data = "";
      });
      print('${error.toString()}');
    });
  }
}
