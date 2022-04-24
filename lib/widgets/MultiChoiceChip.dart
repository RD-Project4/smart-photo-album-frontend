import 'package:flutter/material.dart';

class MultiChoiceChip extends StatefulWidget {
  final Set<String> reportList;
  final Function(Set<String>)? onSelectionChanged;

  MultiChoiceChip(this.reportList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiChoiceChip> {
  Set<String> selectedChoices = Set();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.reportList.map((item) {
        return Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: Text(item),
            selected: selectedChoices.contains(item),
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
