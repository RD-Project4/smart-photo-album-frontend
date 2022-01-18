import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_album/HomePage.dart';
import 'package:smart_album/PhotoList.dart';
import 'package:smart_album/widgets/AccountButton.dart';
import 'package:smart_album/widgets/SearchBar.dart';

import 'CatagoryPage.dart';
import 'util/PermissionUtil.dart';

void main() {
  runApp(MyApp());
  // BlocOverrides.runZoned(() => runApp(MyApp()),
  //     blocObserver: PhotoListModeObserver());
}

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

    await PermissionUtil.requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: IndexedStack(
          children: [
            HomePage(),
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
              icon: Icon(Icons.category),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'My',
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
