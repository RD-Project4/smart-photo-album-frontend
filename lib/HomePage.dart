import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:smart_album/widgets/AccountButton.dart';
import 'package:smart_album/widgets/SearchBar.dart';
import 'package:smart_album/widgets/SelectionToolBar.dart';

import 'PhotoList.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => PhotoListCubit(),
        child: BlocBuilder<PhotoListCubit, PhotoListState>(
            builder: (context, state) {
          final photoListMode = state.mode;
          return Stack(
            children: [
              Positioned(child: PhotoList(isHasTopBar: true)),
              photoListMode == PhotoListMode.View
                  ? SearchBar()
                  : Positioned(child: SelectionToolBar())
            ],
          );
        }));
  }
}
