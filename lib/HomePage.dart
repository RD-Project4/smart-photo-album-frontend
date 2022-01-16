import 'package:flutter/cupertino.dart';
import 'package:smart_album/widgets/AccountButton.dart';
import 'package:smart_album/widgets/SearchBar.dart';
import 'package:smart_album/widgets/SelectionToolBar.dart';

import 'PhotoList.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(child: PhotoList(isHasTopBar: true)),
        // Positioned(child: SelectionToolBar()),
        SearchBar(),
      ],
    );
  }
}
