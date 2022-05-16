import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:recognition_qrcode/recognition_qrcode.dart';
import 'package:smart_album/ShareViewPage.dart';

class ScannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // Barcode? scanRes;
  QRViewController? controller;
  ValueNotifier<Barcode?> _scanRes = ValueNotifier(null);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scanRes.addListener(() {
      if (_scanRes.value == null) {
        return;
      }

      var url = _scanRes.value!.code;

      if (!url!.contains("smartAlbum.com")) {
        // 如果扫描到的url不是分享的url
        return;
      } else {
        // 如果扫描到的url是分享的url
        // 则跳转到分享页面
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShareViewPage(
              shareId: url.split("/").last,
            ),
          ),
        );
      }
    });
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Positioned(
            left: 20,
            top: 20,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
              child: Center(
                  child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back))),
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
              child: Center(
                  child: IconButton(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        print('***********');
                        print(image!.path);
                        print('***********');
                        RecognitionQrcode.recognition(image.path)
                            .then((result) {
                          print('***********');
                          print("recognition: $result");
                          print('***********');
                        });
                      },
                      color: Colors.white,
                      icon: Icon(Icons.photo_library))),
            ),
          ),
        ],
      ),
    ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _scanRes.value = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
