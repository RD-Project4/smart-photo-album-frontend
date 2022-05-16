import 'package:card_swiper/card_swiper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:smart_album/bloc/search/SearchState.dart';
import 'package:smart_album/pages/photo/PhotoPage.dart';
import 'package:smart_album/widgets/OutlineCard.dart';
import 'package:smart_album/widgets/ThumbnailImageProvider.dart';

import 'bloc/search/SearchCubit.dart';
import 'model/Photo.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);

    return BlocBuilder<SearchCubit, SearchState>(
        builder: (context, searchState) =>
            BlocBuilder<PhotoListCubit, PhotoListState>(
                builder: (context, photoListState) {
              if (searchState.searchResult == null) return Container();

              var photoListCubit = context.read<PhotoListCubit>();
              Map<dynamic, List<Photo>> groupedPhotos =
                  photoListCubit.groupByPhotos(searchState.searchResult!);
              List<dynamic> keys;
              if (groupedPhotos is Map<DateTime, List<Photo>>)
                keys = groupedPhotos.keys
                    .sorted((DateTime a, DateTime b) => b.compareTo(a))
                    .toList();
              keys = groupedPhotos.keys.toList();

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
                          return InkWell(
                            child: Container(
                                decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: ThumbnailImageProvider(photoList[index]),
                                fit: BoxFit.cover,
                              ),
                            )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return PhotoPage(
                                      photoList: photoList,
                                      initialIndex: index,
                                    );
                                  },
                                ),
                              );
                            },
                          );
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
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: data.padding.bottom + 10,
                      top: 20),
                  child: Column(
                    children: widgetList,
                  ));
            }));
  }
}
