import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/SearchQuery.dart';
import 'package:smart_album/SearchResult.dart';
import 'package:smart_album/bloc/search/SearchCubit.dart';
import 'package:smart_album/bloc/search/SearchState.dart';
import 'package:smart_album/tensorflow/TensorflowProvider.dart';

import 'CustomSearchBar/CustomFloatingSearchBar.dart';
import 'ChipsInput.dart';
import 'package:collection/collection.dart';

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
            .where((label) => label.startsWith(query))
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
      automaticallyImplyBackButton: false,
      automaticallyImplyDrawerHamburger: false,
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
            onPressed: () {
              controller.clear();
              var cubit = context.read<SearchCubit>();
              if (cubit.hasSearchResult()) cubit.clearSearchResult();
            },
          ),
        ),
        FloatingSearchBarAction(
          showIfOpened: true,
          showIfClosed: false,
          child: CircularButton(
              icon: Icon(Icons.search),
              onPressed: () {
                context.read<SearchCubit>().search();
                FocusScope.of(context).unfocus();
              }),
        ),
        _buildOverflowMenuAction()
      ],
      leadingActions: [
        FloatingSearchBarAction(
          showIfOpened: true,
          builder: (context, animation) {
            final isLTR = Directionality.of(context) == TextDirection.ltr;

            return AnimatedBuilder(
              child: RotatedBox(
                quarterTurns: (isLTR ? 0 : 2),
                child: AnimatedIcon(
                  icon: AnimatedIcons.menu_arrow,
                  textDirection: TextDirection.ltr,
                  progress: animation,
                ),
              ),
              animation: animation,
              builder: (context, icon) => CircularButton(
                tooltip: animation.isDismissed
                    ? MaterialLocalizations.of(context).openAppDrawerTooltip
                    : MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () {
                  final bar = FloatingSearchAppBar.of(context);
                  if (bar?.isOpen == true) {
                    var cubit = context.read<SearchCubit>();
                    if (cubit.hasSearchResult())
                      cubit.clearSearchResult();
                    else
                      bar?.close();
                  } else {
                    Scaffold.of(context).openDrawer();
                  }
                },
                icon: icon!,
              ),
            );
          },
        )
      ],
      transition: ExpandingFloatingSearchBarTransition(),
      builder: (context, transition) {
        return BlocBuilder<SearchCubit, SearchState>(
            builder: ((context, state) => IndexedStack(
                  index: state.searchResult == null ? 0 : 1,
                  children: [
                    const SearchQuery(isHasBottom: true),
                    SearchResult(),
                  ],
                )));
      },
    );
  }

  FloatingSearchBarAction _buildOverflowMenuAction() {
    return FloatingSearchBarAction(
        showIfOpened: true,
        showIfClosed: true,
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: ((context, state) => PopupMenuButton<int>(
                itemBuilder: (context) {
                  List<PopupMenuEntry<int>> widgetList = [];
                  List<String> groupByItem = [
                    "Create Time",
                    "Label",
                    "Location",
                    "Image Size"
                  ];
                  widgetList.add(PopupMenuTitle(child: Text("Group by")));
                  num checkedIndex = state.groupBy.index;
                  groupByItem.forEachIndexed((index, item) {
                    widgetList.add(CheckablePopupMenuItem(
                        isChecked: index == checkedIndex,
                        child: Text(item)));
                  });
                  widgetList.addAll([
                    PopupMenuDivider(),
                    PopupMenuTitle(child: Text("Order by")),
                    CheckablePopupMenuItem(
                        isChecked: true,
                        child: Text("Create Time")), // Maybe more?
                  ]);
                  return widgetList;
                },
              )),
        ));
  }
}

class PopupMenuTitle<T> extends PopupMenuItem<T> {
  PopupMenuTitle({required Widget? child})
      : super(
            child: child,
            textStyle: TextStyle(color: Colors.grey, fontSize: 14));
}

class CheckablePopupMenuItem<T> extends PopupMenuItem<T> {
  final bool isChecked;

  CheckablePopupMenuItem({required Widget child, this.isChecked = false})
      : super(
          child: Row(
            children: [
              Expanded(child: child),
              Icon(isChecked
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off),
            ],
          ),
        );
}
