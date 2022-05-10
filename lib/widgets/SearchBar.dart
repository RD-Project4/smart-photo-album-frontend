import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/SearchQuery.dart';
import 'package:smart_album/SearchResult.dart';
import 'package:smart_album/bloc/search/SearchCubit.dart';
import 'package:smart_album/bloc/search/SearchState.dart';
import 'package:smart_album/tensorflow/TensorflowProvider.dart';

import 'CustomSearchBar/CustomFloatingSearchBar.dart';
import 'ChipsInput.dart';

class Label {
  final String name;

  Label(this.name);
}

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

    SearchCubit cubit = context.read<SearchCubit>();

    return CustomFloatingSearchBar(
      textFieldBuilder: (state) => ChipsInput<Label>(
        chipBuilder: (context, state, label) => InputChip(
          label: Text(label.name),
          onDeleted: () => state.deleteChip(label),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        suggestionBuilder: (context, label) => ListTile(
          title: Text(label.name),
        ),
        onChanged: (data) =>
            cubit.setLabelList(data.map((label) => label.name).toList()),
        findSuggestions: (query) async => (await TensorflowProvider.getLabels())
            .where((label) => label.contains(query))
            .where((label) => !cubit.containsLabel(label))
            .map((label) => Label(label))
            .toList(),
        controller: state.inputController,
        showCursor: state.widget.showCursor,
        focusNode: state.inputController.node,
        maxLines: 1,
        autofocus: false,
        toolbarOptions: state.widget.toolbarOptions,
        cursorColor: state.style.accentColor,
        style: state.style.queryStyle,
        textInputAction: state.widget.textInputAction,
        keyboardType: state.widget.textInputType,
        decoration: InputDecoration(
          isDense: true,
          hintStyle: state.style.hintStyle,
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
      controller: controller,
      hint: 'Type to search',
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
