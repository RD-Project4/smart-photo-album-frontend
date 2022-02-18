import 'package:flutter/material.dart';
import 'package:smart_album/DataProvider.dart';
import 'package:smart_album/widgets/MultiChoiceChip.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SearchResult extends StatelessWidget {
  SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var photoList = DataProvider.getElements();
    List<String> labels = [];
    for (var photo in photoList) {
      labels.addAll(photo["labels"]);
    }

    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Title("Category"),
            MultiChoiceChip(labels),
            _Title("Date"),
            SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.multiRange,
            ),
            _Title("Location"),
            MultiChoiceChip(["Hangzhou", "Beijing", "Ningbo", "Suzhou"]),
          ],
        ));
  }
}

class _Title extends StatelessWidget {
  final textStyle = TextStyle(fontSize: 18);

  final String text;

  _Title(this.text) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(text, style: textStyle),
    );
  }
}
