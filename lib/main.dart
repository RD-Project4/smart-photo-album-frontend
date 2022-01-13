import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:smart_album/PhotoList.dart';
import 'package:smart_album/widgets/AccountButton.dart';
import 'package:smart_album/widgets/SearchBar.dart';

import 'CatagoryPage.dart';
import 'util/PermissionUtil.dart';
import 'common/Global.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    var res = await PermissionUtil.requestStoragePermission();
    var res2 = await PermissionUtil.requestPhotosPermission();
    if (res && res2) {
      print('yes');
      final file = File('${Global.ROOT_PATH}Download/a.txt');
      final contents = await file.readAsString();
      print(contents);
    } else {
      print('no');
    }

    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      // success
      print('success');
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList(onlyAll: true);
      list.forEach((e) async{
        if(e.name == "Recent"){
          var imgList = await e.assetList;
          imgList.forEach((img) {
            print(img.createDateTime);
            print(img.title);
          });
        }
      });
    } else {
      // fail
      print('fail');
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: IndexedStack(
          children: [
            SearchBar(
              scrollTarget: PhotoList(isHasTopBar: true),
              tailing: AccountButton(),
            ),
            CategoryPage(),
            Container()
          ],
          index: _selectedIndex,
        )),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.backup_outlined),
              label: 'Backup',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.indigo,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
