import 'package:flutter/material.dart';
import 'package:smart_album/widgets/LightAppBar.dart';

import '../SearchResult.dart';

class AddCategoryFolder extends StatelessWidget {
  const AddCategoryFolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchResult = SearchResult();

    return Scaffold(
        appBar: LightAppBar(
          context,
          "Add Category Folder",
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Enter your folder name',
                ),
              ),
            ),
            searchResult
          ],
        )));
  }
}
