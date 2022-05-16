import 'package:flutter/material.dart';

class ListedChips<T> extends StatelessWidget {
  final List<T> itemList;
  final Widget Function(T) buildLabel;
  final void Function(T item) onTap;

  const ListedChips(
      {Key? key,
      required this.itemList,
      required this.buildLabel,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: itemList.map((item) {
        return Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            selected: false,
            label: buildLabel(item),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade200, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
            selectedColor: Colors.blueAccent,
            backgroundColor: Colors.transparent,
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            onSelected: (bool) => onTap(item),
          ),
        );
      }).toList(),
    );
  }
}
