import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class MultiChoiceChip extends StatefulWidget {
  final List<String> availableList;
  final Function(Set<String>)? onSelectionChanged;
  late final Set<String>? initSelected;
  final bool hasMore;

  MultiChoiceChip(this.availableList,
      {this.onSelectionChanged, this.initSelected, this.hasMore = false}) {
    if (hasMore) availableList.add("More");
  }

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiChoiceChip> {
  late Set<String> selectedChoices;

  @override
  void initState() {
    super.initState();
    selectedChoices = widget.initSelected ?? Set();
  }

  @override
  void didUpdateWidget(covariant MultiChoiceChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initSelected != null) selectedChoices = widget.initSelected!;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.availableList.mapIndexed((index, item) {
        bool isSelected = selectedChoices.contains(item);

        return Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: widget.hasMore && index == widget.availableList.length - 1
                ? Row(children: [
                    Icon(Icons.keyboard_arrow_down_outlined),
                    Text(item)
                  ])
                : Text(item),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade200, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
            selectedColor: Colors.blueAccent,
            backgroundColor: Colors.transparent,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                selectedChoices.contains(item)
                    ? selectedChoices.remove(item)
                    : selectedChoices.add(item);
                widget.onSelectionChanged?.call(selectedChoices);
              });
            },
          ),
        );
      }).toList(),
    );
  }
}
