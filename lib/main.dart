import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_album/PhotoList.dart';
import 'package:smart_album/widgets/AccountButton.dart';
import 'package:smart_album/widgets/SearchBar.dart';

// import 'package:toast/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_album_manager/photo_album_manager.dart';

import 'CatagoryPage.dart';
import 'util/PermissionUtil.dart';

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
    // print(await PermissionUtil.requestStoragePermission());
    PermissionStatus status = await PhotoAlbumManager.checkPermissions();
    if (status == PermissionStatus.granted) {
      print('权限同意');
    } else {
      print('权限拒绝');
    }
    //再获取相册资源
    List<AlbumModelEntity> photos =
        await PhotoAlbumManager.getDescAlbum(maxCount: 50);
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
