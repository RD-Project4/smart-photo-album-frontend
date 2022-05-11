import 'package:card_swiper/card_swiper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_album/bloc/search/SearchState.dart';
import 'package:smart_album/widgets/OutlineCard.dart';

import 'bloc/search/SearchCubit.dart';
import 'model/Photo.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(builder: ((context, state) {
      if (state.searchResult == null) return Container();

      Map<dynamic, List<Photo>> groupedPhotos;
      List<String> keys;
      switch (state.groupBy) {
        case GroupByOption.CREATE_TIME:
          Map<DateTime, List<Photo>> typedGroupedPhotos = state.searchResult!
              .groupListsBy((photo) => photo.creationDateTime);
          groupedPhotos = typedGroupedPhotos;
          var unsortedKeys = typedGroupedPhotos.keys;
          DateFormat dateFormatter = DateFormat.yMMMEd('en_US');
          keys = unsortedKeys
              .sorted((DateTime a, DateTime b) => b.compareTo(a))
              .map((e) => dateFormatter.format(e))
              .toList();
          break;
        case GroupByOption.LABEL:
          Map<String, List<Photo>> typedGroupedPhotos =
              state.searchResult!.groupListsBy((photo) => photo.labels[0]);
          groupedPhotos = typedGroupedPhotos;
          keys = typedGroupedPhotos.keys.toList();
          break;
        case GroupByOption.LOCATION:
          Map<String, List<Photo>> typedGroupedPhotos = state.searchResult!
              .where((photo) => photo.location != null)
              .groupListsBy((photo) => photo.location!);
          groupedPhotos = typedGroupedPhotos;
          keys = typedGroupedPhotos.keys.toList();
          break;
        default:
          groupedPhotos = Map();
          keys = [];
      }

      var spacing = const EdgeInsets.all(10);
      List<Widget> widgetList = [];
      for (var key in keys) {
        widgetList.add(OutlineCard(
          margin: spacing,
          title: key,
          child: Swiper(
            containerWidth: 200,
            containerHeight: 200,
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                "https://via.placeholder.com/288x188",
                fit: BoxFit.fill,
              );
            },
            itemCount: 10,
            scale: 0.9,
          ),
        ));
      }

      return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(left: 12, right: 12, bottom: 10, top: 20),
          child: Column(
            children: widgetList,
          ));
    }));
  }
}
