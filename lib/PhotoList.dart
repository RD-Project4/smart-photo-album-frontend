import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:smart_album/widgets/GroupedView.dart';

import 'FakeData.dart';
import 'PhotoView.dart';
import 'package:collection/collection.dart';

class PhotoList extends StatelessWidget {
  final bool isHasTopBar;

  const PhotoList({Key? key, this.isHasTopBar = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GroupedView<dynamic, DateTime>(
        padding:
            isHasTopBar ? const EdgeInsets.only(top: kToolbarHeight) : null,
        elements: DataProvider.getElements(),
        groupBy: (element) => element['time'],
        groupComparator: (value1, value2) => -value2.compareTo(value1),
        order: GroupedListOrder.DESC,
        floatingHeader: false,
        groupSeparatorBuilder: (DateTime date) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${date.month}.${date.day}',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
        sectionBuilder:
            (context, currentSectionElementList, allElement, overallIndex) {
          return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: currentSectionElementList
                  .mapIndexed((index, element) => InkWell(
                      child: Container(
                          margin : EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/" + element['name']),
                          fit: BoxFit.cover,
                        ),
                      )),
                      onTap: () =>
                          _open(context, allElement, overallIndex + index)))
                  .toList());
        });
  }

  void _open(BuildContext context, List elements, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoView<dynamic>(
          imageBuilder: (item) => AssetImage("images/" + item['name']),
          descBuilder: (item) => Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 10,
                children: (item['tag'] as List<String>)
                    .map((element) => Chip(label: Text(element)))
                    .toList(),
              )),
          galleryItems: elements,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
        ),
      ),
    );
  }
}
