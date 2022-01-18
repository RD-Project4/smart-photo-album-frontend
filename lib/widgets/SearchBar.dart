import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:smart_album/SearchResult.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';

import 'AccountButton.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return BlocProvider(
        create: (_) => PhotoListCubit(),
        child: BlocBuilder<PhotoListCubit, PhotoListState>(
          builder: (context, state) {
            return FloatingSearchBar(
              hint: '',
              backdropColor: Colors.white,
              scrollPadding: EdgeInsets.zero,
              transitionDuration: const Duration(milliseconds: 300),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              axisAlignment: 0.0,
              openAxisAlignment: 0.0,
              width: isPortrait ? 600 : 500,
              debounceDelay: const Duration(milliseconds: 500),
              onQueryChanged: (query) {
                // Call your model, bloc, controller here.
              },
              clearQueryOnClose: true,
              actions: [
                FloatingSearchBarAction(
                  showIfOpened: false,
                  showIfClosed: true,
                  child: AccountButton(),
                )
              ],
              leadingActions: [
                FloatingSearchBarAction(
                  showIfOpened: true,
                  showIfClosed: false,
                  child: CircularButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                  ),
                )
              ],
              transition: ExpandingFloatingSearchBarTransition(),
              builder: (context, transition) {
                return SearchResult();
              },
            );
          },
        ));
  }
}
