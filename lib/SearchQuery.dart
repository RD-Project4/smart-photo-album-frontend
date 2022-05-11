import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/search/SearchCubit.dart';
import 'package:smart_album/database/HIstory.dart';
import 'package:smart_album/widgets/MultiChoiceChip.dart';
import 'package:smart_album/widgets/OutlineCard.dart';
import 'package:smart_album/widgets/QueryStreamBuilder.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tuple/tuple.dart';

class SearchQuery extends StatelessWidget {
  final bool isHasBottom;

  SearchQuery({Key? key, this.isHasBottom = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final SearchCubit cubit = context.read<SearchCubit>();

    num padding = isHasBottom ? data.padding.bottom : 0;
    EdgeInsets spacing = const EdgeInsets.all(10);

    return SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding:
            EdgeInsets.only(left: 12, right: 12, bottom: padding + 10, top: 20),
        child: Column(
          children: [
            // _Title("Category"),
            // QueryStreamBuilder<Photo>(
            //     queryStream: PhotoViewModel.getPhotoList(),
            //     loadingWidget: LoadingCircle(),
            //     builder: (context, data) {
            //       var photoList = data;
            //       Set<String> labels = Set();
            //       for (var photo in photoList) {
            //         labels.addAll(photo.labels);
            //       }
            //       return MultiChoiceChip(labels,
            //           onSelectionChanged: (labelSet) {
            //         context.read<SearchCubit>().setLabelList(labelSet.toList());
            //       });
            //     }),
            OutlineCard(
                margin: spacing,
                title: "Search History",
                child: QueryStreamBuilder<History>(
                  queryStream: cubit.getHistory(),
                  builder: ((context, historyList) => MultiChoiceChip(
                      Set.from(historyList.map((e) => e.name)))),
                )),
            OutlineCard(
                margin: spacing,
                title: "Date",
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.range,
                  onSelectionChanged: (args) {
                    PickerDateRange range = args.value;
                    if (range.endDate != null && range.endDate != null)
                      cubit.setDateRange(
                          Tuple2(range.startDate!, range.endDate!));
                    else
                      cubit.setDateRange(null);
                  },
                )),
            OutlineCard(
                margin: spacing,
                title: "Location",
                child: MultiChoiceChip(
                    Set.from(["Hangzhou", "Beijing", "Ningbo", "Suzhou"]))),
          ],
        ));
  }
}
