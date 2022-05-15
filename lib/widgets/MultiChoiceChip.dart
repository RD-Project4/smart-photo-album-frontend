import 'package:flutter/material.dart';

class MultiChoiceChip extends StatefulWidget {
  final Set<String> reportList;
  final Function(Set<String>)? onSelectionChanged;
  late final Set<String> initSelected;

  MultiChoiceChip(this.reportList,
      {this.onSelectionChanged, Set<String>? initSelected}) {
    this.initSelected = initSelected ?? Set();
  }

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiChoiceChip> {
  late Set<String> selectedChoices;

  @override
  void initState() {
    super.initState();
    selectedChoices = widget.initSelected;
  }

  @override
  void didUpdateWidget(covariant MultiChoiceChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedChoices = widget.initSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.reportList.map((item) {
        return Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: Text(item),
            selectedColor: Colors.blueAccent.withOpacity(0.3),
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
