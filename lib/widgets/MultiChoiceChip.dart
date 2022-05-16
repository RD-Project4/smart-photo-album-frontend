import 'package:flutter/material.dart';

class MultiChoiceChip extends StatefulWidget {
  final Set<String> availableList;
  final Function(Set<String>)? onSelectionChanged;
  late final Set<String>? initSelected;

  MultiChoiceChip(this.availableList,
      {this.onSelectionChanged, this.initSelected});

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
      children: widget.availableList.map((item) {
        bool isSelected = selectedChoices.contains(item);

        return Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: Text(item),
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
