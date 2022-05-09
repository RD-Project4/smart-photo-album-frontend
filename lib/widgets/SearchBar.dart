import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:smart_album/SearchQuery.dart';
import 'package:smart_album/SearchResult.dart';
import 'package:smart_album/bloc/search/SearchCubit.dart';
import 'package:smart_album/bloc/search/SearchState.dart';

class SearchBar extends StatelessWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SearchCubit(), child: _SearchBarContent());
  }
}

class _SearchBarContent extends StatelessWidget {
  final FloatingSearchBarController controller = FloatingSearchBarController();

  _SearchBarContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: controller,
      hint: '',
      isScrollControlled: true,
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
        context.read<SearchCubit>().setText(query);
      },
      clearQueryOnClose: true,
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          showIfClosed: true,
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/scanner');
            },
            icon: Icon(Icons.qr_code_scanner),
          ),
        ),
        FloatingSearchBarAction(
          showIfOpened: true,
          showIfClosed: false,
          child: CircularButton(
            icon: Icon(Icons.clear),
            onPressed: () => controller.clear(),
          ),
        ),
        FloatingSearchBarAction(
          showIfOpened: true,
          showIfClosed: false,
          child: CircularButton(
              icon: Icon(Icons.search),
              onPressed: () => context.read<SearchCubit>().search()),
        )
      ],
      // leadingActions: [
      //   FloatingSearchBarAction(
      //     showIfOpened: true,
      //     showIfClosed: false,
      //     child: CircularButton(
      //       icon: const Icon(Icons.arrow_back),
      //       onPressed: () {
      //         Navigator.maybePop(context);
      //       },
      //     ),
      //   )
      // ],
      transition: ExpandingFloatingSearchBarTransition(),
      builder: (context, transition) {
        return BlocBuilder<SearchCubit, SearchState>(
            builder: ((context, state) => state.searchResult == null
                ? SearchQuery(isHasBottom: true)
                : SearchResult()));
      },
    );
  }
}
