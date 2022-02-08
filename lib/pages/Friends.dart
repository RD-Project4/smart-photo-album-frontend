import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:smart_album/widgets/GroupedView.dart';
import 'package:smart_album/widgets/ListedPhoto.dart';

class Friends extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  var friends = <Map>[
    {'name': 'aaa'},
    {'name': 'baa'},
    {'name': 'Daa'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Friends',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: GroupedView<dynamic, String>(
          padding: null,
          elements: friends,
          groupBy: (element) {
            return element['name'];
          },
          groupComparator: (value1, value2) => -value2.compareTo(value1),
          order: GroupedListOrder.DESC,
          floatingHeader: false,
          groupSeparatorBuilder: (String str) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  str,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
          sectionBuilder:
              (context, currentSectionElementList, allElement, overallIndex) {
            return GridView.count(
                // 照片
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: currentSectionElementList
                    .mapIndexed((index, element) => Text(element['name']))
                    .toList());
          }),
    );
  }
}
