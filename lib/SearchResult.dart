import 'package:card_swiper/card_swiper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_album/bloc/search/SearchState.dart';
import 'package:smart_album/widgets/OutlineCard.dart';
import 'package:smart_album/widgets/ThumbnailImageProvider.dart';

import 'bloc/search/SearchCubit.dart';
import 'model/Photo.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);

    return BlocBuilder<SearchCubit, SearchState>(builder: ((context, state) {
      if (state.searchResult == null) return Container();

      Map<dynamic, List<Photo>> groupedPhotos;
      List<dynamic> keys;
      switch (state.groupBy) {
        case GroupByOption.CREATE_TIME:
          Map<DateTime, List<Photo>> typedGroupedPhotos =
              state.searchResult!.groupListsBy((photo) {
            DateTime dateTime = photo.creationDateTime;
            return DateTime(dateTime.year, dateTime.month, dateTime.day);
          });
          groupedPhotos = typedGroupedPhotos;
          var unsortedKeys = typedGroupedPhotos.keys;
          keys = unsortedKeys
              .sorted((DateTime a, DateTime b) => b.compareTo(a))
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

      DateFormat dateFormatter = DateFormat.yMMMEd('en_US');
      var spacing = const EdgeInsets.all(10);
      List<Widget> widgetList = [];
      for (var key in keys) {
        List<Photo> photoList = groupedPhotos[key]!;
        if (key is DateTime) key = dateFormatter.format(key);
        widgetList.add(OutlineCard(
          margin: spacing,
          title: key,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 200,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: ThumbnailImageProvider(photoList[index]),
                      fit: BoxFit.cover,
                    ),
                  ));
                },
                itemCount: photoList.length,
                viewportFraction: 0.8,
                scale: 0.9,
              ),
            ),
          ),
        ));
      }

      return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
              left: 12, right: 12, bottom: data.padding.bottom + 10, top: 20),
          child: Column(
            children: widgetList,
          ));
    }));
  }
}
