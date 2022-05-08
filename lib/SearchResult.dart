import 'package:flutter/material.dart';
import 'package:smart_album/viewModel/PhotoViewModel.dart';
import 'package:smart_album/util/ListUtil.dart';
import 'package:smart_album/widgets/LoadingCircle.dart';
import 'package:smart_album/widgets/MultiChoiceChip.dart';
import 'package:smart_album/widgets/QueryStreamBuilder.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'database/Photo.dart';

class SearchResult extends StatelessWidget {
  String? searchLabel;

  final bool isHasBottom;

  SearchResult({Key? key, this.isHasBottom = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    num padding = isHasBottom ? data.padding.bottom : 0;

    return SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(left: 10, right: 10, bottom: padding + 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Title("Category"),
            QueryStreamBuilder<Photo>(
                queryStream: PhotoViewModel.getPhotoList(),
                loadingWidget: LoadingCircle(),
                builder: (context, data) {
                  var photoList = data;
                  Set<String> labels = Set();
                  for (var photo in photoList) {
                    labels.addAll(photo.labels);
                  }
                  return MultiChoiceChip(labels, onSelectionChanged: (label) {
                    searchLabel = label.length > 0 ? label.first : null;
                  });
                }),
            _Title("Date"),
            SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.multiRange,
            ),
            _Title("Location"),
            MultiChoiceChip(
                Set.from(["Hangzhou", "Beijing", "Ningbo", "Suzhou"])),
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
