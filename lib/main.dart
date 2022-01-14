import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:smart_album/PhotoList.dart';
import 'package:smart_album/store/PhotoListModeState.dart';
import 'package:smart_album/widgets/AccountButton.dart';
import 'package:smart_album/widgets/SearchBar.dart';

import 'CatagoryPage.dart';
import 'util/PermissionUtil.dart';

void main(){
  final photoListModeStore = Store<PhotoListModeState>(PhotoListModeState.reducer,initialState: PhotoListModeState.initState());
  runApp(MyApp());
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
