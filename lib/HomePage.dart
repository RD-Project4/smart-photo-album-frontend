import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:smart_album/widgets/SearchBar.dart';
import 'package:smart_album/widgets/SelectionToolBar.dart';

import 'PhotoList.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => PhotoListCubit(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(child: PhotoList(isHasTopBar: true)),
            BlocBuilder<PhotoListCubit, PhotoListState>(
                builder: (context, state) => state.mode == PhotoListMode.View
                    ? SearchBar()
                    : Positioned(
                        left: 0,
                        right: 0,
                        height: kToolbarHeight,
                        child: SelectionToolBar())),
          ],
        ));
  }
}
