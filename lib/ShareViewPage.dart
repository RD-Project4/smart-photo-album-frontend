import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:smart_album/api/api.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/pages/photo/PhotoPage.dart';
import 'package:smart_album/widgets/LightAppBar.dart';
import 'package:smart_album/widgets/LoadingCircle.dart';
import 'package:smart_album/widgets/PhotoGroupedView.dart';

class ShareViewPage extends StatelessWidget {
  final String shareId;

  const ShareViewPage({Key? key, required this.shareId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Api.get().getSharePhotoList(shareId),
      builder: (context, snapshot) {
        if (snapshot.data != null)
          return Scaffold(
              appBar: LightAppBar(context, "Shared by others"),
              body: BlocProvider(
                  create: (context) => PhotoListCubit(),
                  child: PhotoGroupedView(
                      photos: snapshot.data as List<Photo>,
                      onTap: (photo, index, sortedPhotoList) =>
                          open(context, sortedPhotoList, index))));
        else if (snapshot.error != null) {
          showToast("Login first");
          Navigator.pushNamed(context, "/login");
          return Container();
        } else {
          return Scaffold(
              body: SizedBox.expand(
            child: Center(child: LoadingCircle()),
          ));
        }
      },
    );
  }

  static void open(
      BuildContext context, List<Photo> elements, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return PhotoPage(
            photoList: elements,
            initialIndex: index,
          );
        },
      ),
    );
  }
}
