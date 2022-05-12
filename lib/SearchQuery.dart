import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/search/SearchCubit.dart';
import 'package:smart_album/bloc/search/SearchState.dart';
import 'package:smart_album/tensorflow/TensorflowProvider.dart';
import 'package:smart_album/widgets/LoadingCircle.dart';
import 'package:smart_album/widgets/MultiChoiceChip.dart';
import 'package:smart_album/widgets/OutlineCard.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tuple/tuple.dart';

class SearchQuery extends StatelessWidget {
  final bool isHasBottom;
  final bool isTopPadding;

  final bool showLabels;
  final bool showHistory;

  const SearchQuery(
      {Key? key,
      this.isHasBottom = false,
      this.isTopPadding = true,
      this.showHistory = true,
      this.showLabels = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final SearchCubit cubit = context.read<SearchCubit>();

    num padding = isHasBottom ? data.padding.bottom : 0;
    EdgeInsets spacing = const EdgeInsets.all(10);

    List<Widget> widgetList = [];
    if (showLabels)
      widgetList.add(OutlineCard(
          margin: spacing,
          title: "Labels",
          child: BlocBuilder<SearchCubit, SearchState>(
              builder: ((context, state) => state.historyList == null
                  ? LoadingCircle()
                  : FutureBuilder(
                      future: TensorflowProvider.getLabels(),
                      builder: (context, snapshot) => snapshot.data == null
                          ? Container()
                          : MultiChoiceChip(
                              Set.from(snapshot.data as List<String>),
                              onSelectionChanged: (result) =>
                                  cubit.setLabelList(result.toList()),
                            ))))));
    if (showHistory)
      widgetList.add(OutlineCard(
          margin: spacing,
          title: "Search History",
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: ((context, state) => state.historyList == null
                ? LoadingCircle()
                : MultiChoiceChip(
                    Set.from(state.historyList!.map((e) => e.name)))),
          )));
    widgetList.addAll([
      OutlineCard(
          margin: spacing,
          title: "Date",
          child: SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.range,
            onSelectionChanged: (args) {
              PickerDateRange range = args.value;
              if (range.endDate != null && range.endDate != null)
                cubit.setDateRange(Tuple2(range.startDate!, range.endDate!));
              else
                cubit.setDateRange(null);
            },
          )),
      OutlineCard(
          margin: spacing,
          title: "Location",
          child: MultiChoiceChip(
            Set.from(cubit.getCities()),
            onSelectionChanged: (cities) =>
                cubit.setLocationList(cities.toList()),
          ))
    ]);

    return SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: padding + 10,
            top: isTopPadding ? 20 : 0),
        child: Column(
          children: widgetList,
        ));
  }
}
