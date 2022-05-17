import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/categoryFolder/AddCategoryState.dart';
import 'package:smart_album/bloc/search/SearchCubit.dart';
import 'package:smart_album/util/DialogUtil.dart';
import 'package:smart_album/widgets/LightAppBar.dart';

import '../SearchQuery.dart';

class AddCategoryFolder extends StatelessWidget {
  const AddCategoryFolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = AddCategoryCubit();

    return BlocProvider<SearchCubit>(
        create: (context) => cubit,
        child: Scaffold(
            appBar: LightAppBar(
              context,
              "Create new folder",
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (cubit.state.text.length <= 0) {
                      DialogUtil.showWarningDialog(
                          context, "Error", "Folder name should not be empty");
                      return;
                    }
                    if (cubit.state.labelList.length <= 0) {
                      DialogUtil.showWarningDialog(context, "Error",
                          "You should select at least one label");
                      return;
                    }
                    cubit.addCategory();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Enter your folder name',
                    ),
                    onChanged: (value) => cubit.setName(value),
                  ),
                ),
                GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SearchQuery(
                      isTopPadding: false,
                      showLabels: true,
                      showHistory: false,
                    ))
              ],
            ))));
  }
}
