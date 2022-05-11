import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_album/widgets/TabsDrawer.dart';

import '../CatagoryPage.dart';
import '../HomePage.dart';
import '../util/ThemeUtils.dart';
import 'tabs/Setting.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  late List<Widget> pages;

  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    pages = [HomePage(), CategoryPage(), Setting()];
  }

  @override
  Widget build(BuildContext context) {
    ThemeUtils.setSystemOverlayLight(context);

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          children: pages,
          index: _selectedPageIndex,
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Colors.blueGrey.shade50,
          index: _selectedPageIndex,
          onTap: (int index) {
            setState(() {
              _selectedPageIndex = index;
            });
          },
          items: [
            Icon(Icons.home, size: 20),
            Icon(Icons.category, size: 20),
            Icon(Icons.person, size: 20),
          ]),
      drawer: TabsDrawer(),
      onDrawerChanged: (isOpened) {
        // showuser();
      },
    );
  }
}
