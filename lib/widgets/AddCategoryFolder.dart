import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/categoryFolder/AddCategoryState.dart';
import 'package:smart_album/bloc/search/SearchCubit.dart';
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
              "Add Category Folder",
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
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
