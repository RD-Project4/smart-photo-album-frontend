import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:smart_album/widgets/GroupedView.dart';

List _elements = [
  {'name': '1.jpg', 'time': 'Oct.12'},
  {'name': '2.jpg', 'time': 'Oct.10'},
  {'name': '3.jpg', 'time': 'Oct.10'},
  {'name': '4.jpg', 'time': 'Oct.10'},
];

class PhotoList extends StatelessWidget {
  final bool isHasTopBar;

  const PhotoList({Key? key, this.isHasTopBar = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GroupedView<dynamic, String>(
        padding:
            isHasTopBar ? const EdgeInsets.only(top: kToolbarHeight) : null,
        elements: _elements,
        groupBy: (element) => element['time'],
        groupComparator: (value1, value2) => -value2.compareTo(value1),
        order: GroupedListOrder.DESC,
        floatingHeader: false,
        groupSeparatorBuilder: (String value) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
        sectionBuilder: (context, elementList) {
          return GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // Generate 100 widgets that display their index in the List.
              children: elementList
                  .map((element) => Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/" + element['name']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                  .toList());
        });
  }
}
