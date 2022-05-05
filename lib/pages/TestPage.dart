import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:io';
//ByteData这里需要引入dart:typed_data文件，引入service.dart的话app里可以检索到文件个数，但是传递到后台一直是null，时间紧迫我也没抓包看是咋回事儿先这么用吧
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
//MediaType用
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:smart_album/pages/tabs/Setting.dart';

import '../PhotoList.dart';

class TestPage extends StatefulWidget {
  final arguments;
  TestPage({Key? key, this.arguments}) : super(key: key);
  _TestPageState createState() => _TestPageState(this.arguments);
}

class _TestPageState extends State<TestPage> {
  final arguments;
  _TestPageState(this.arguments);
  //上传图片用
  ScrollController _imgController = new ScrollController();
  List<Asset> _img = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.keyboard_return),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("uploading pictures"),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  this._img == null
                      ? Expanded(
                          flex: 1,
                          child: Text(""),
                        )
                      : Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            child: ListView.builder(
                              controller: _imgController,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: this._img.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                        color: Colors.black26,
                                      )),
                                  child: AssetThumb(
                                    asset: this._img[index],
                                    width: 50,
                                    height: 50,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                  InkWell(
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Colors.black26,
                          )),
                      child: Center(
                        child: Icon(Icons.camera_alt),
                      ),
                    ),
                    onTap: _openGallerySystem,
                  )
                ],
              ),
              Container(
                width: 80,
                height: 80,
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _submitData();
                  },
                ),
              ),
            ],
          )),
    );
  }

  //选择文件上传
  void _openGallerySystem() async {
    List<Asset> resultList = [];
    resultList = await MultiImagePicker.pickImages(
      //最多选择几张照片
      maxImages: 4,
      //是否可以拍照
      enableCamera: true,
      selectedAssets: _img,
      materialOptions: MaterialOptions(
          startInAllView: true,
          allViewTitle: 'All Pictures',
          actionBarColor: '#2196F3',
          //未选择图片时提示
          textOnNothingSelected: 'no selecting pictures',
          //选择图片超过限制弹出提示
          selectionLimitReachedText: " only 4 pictures"),
    );
    if (!mounted) return;
    setState(() {
      _img = resultList;
    });
  }

  void _submitData() async {
    List<MultipartFile> imageList = <MultipartFile>[];
    String url = "http://124.223.68.12:8233/smartAlbum/uploadcloudpic.do";

    for (Asset asset in _img) {
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = new MultipartFile.fromBytes(
        imageData,
        filename: 'load_image',
        contentType: MediaType("image", "jpg"),
      );
      imageList.add(multipartFile);
      print("图片数据：$imageData");
    }
    print("图片数量:${imageList.length}");
    FormData formData = FormData.fromMap({
      // "imageList": imageList,
      'imageList': await MultipartFile.fromFile(PhotoList.photopath,
          filename: PhotoList.photoname.toString()),
      // "imageList": [
      //   await MultipartFile.fromFile(PhotoList.photopath, filename: 'test.png'),
      //   await MultipartFile.fromFile(PhotoList.photopath, filename: 'test1.png')
      // ],
      'picOwner': '1073638314@qq.com',
      'label': 'null'
    });

    Dio dio = new Dio();
    var response = await dio.post(
      url,
      data: formData,
    );

    print(response.data);
  }
}
