import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:smart_album/SearchResult.dart';

import '../DataProvider.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String? searchLabel;

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    var searchResult = SearchResult();

    return FloatingSearchBar(
      hint: '',
      isScrollControlled: true,
      backdropColor: Colors.white,
      scrollPadding: EdgeInsets.zero,
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: 0.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      clearQueryOnClose: true,
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          showIfClosed: true,
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/scanner');
            },
            icon: Icon(Icons.qr_code_scanner),
          ),
        ),
        FloatingSearchBarAction(
          showIfOpened: true,
          showIfClosed: false,
          child: CircularButton(
            icon: Icon(searchLabel == null ? Icons.search : Icons.clear),
            onPressed: () {
              setState(() {
                searchLabel =
                    searchLabel == null ? searchResult.searchLabel : null;
              });
            },
          ),
        )
      ],
      // leadingActions: [
      //   FloatingSearchBarAction(
      //     showIfOpened: true,
      //     showIfClosed: false,
      //     child: CircularButton(
      //       icon: const Icon(Icons.arrow_back),
      //       onPressed: () {
      //         Navigator.maybePop(context);
      //       },
      //     ),
      //   )
      // ],
      transition: ExpandingFloatingSearchBarTransition(),
      builder: (context, transition) {
        if (searchLabel != null) {
          var photoList = DataProvider.getPhotoList()
              .where((element) => element.labels.contains(searchLabel))
              .toList();
          return GridView.count(
              // 照片
              crossAxisCount: 2,
              shrinkWrap: true,
              children: photoList
                  .map((element) => Container(
                      margin: EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(element.path)),
                          fit: BoxFit.cover,
                        ),
                      )))
                  .toList());
        } else
          return searchResult;
      },
    );
  }
}
