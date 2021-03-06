import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
// พิมเอง
import 'dart:ui' as ui;
import 'dart:async';

class MyCodeScreen extends StatefulWidget {
  MyCodeScreen({Key key}) : super(key: key);

  @override
  _MyCodeScreenState createState() => _MyCodeScreenState();
}

class _MyCodeScreenState extends State<MyCodeScreen> {
  // กำหนดตัวแปรไว้เก็บ data ของ QR CODE
  final qrdata = 'https://www.itgenius.co.th/contact-us';

  @override
  Widget build(BuildContext context) {
    final qrFutureBuilder = FutureBuilder<ui.Image>(
      future: _loadOverlayImage(),
      builder: (ctx, snapshot) {
        final size = 250.0;
        if (!snapshot.hasData) {
          return Container(width: size, height: size);
        }
        return CustomPaint(
          size: Size.square(size),
          painter: QrPainter(
            data: qrdata,
            version: QrVersions.auto,
            // size: 320.0,
            embeddedImage: snapshot.data,
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size.square(60),
            ),
          ),
        );
      },
    );
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    // width: 250,
                    // child: QrImage(data: qrdata,),
                    child: qrFutureBuilder,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)
                    .copyWith(bottom: 40.0),
                child: Text('$qrdata'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/images/logo_qr.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }
}
