import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/bloc/uploadManager/UploadCubit.dart';
import 'package:smart_album/bloc/uploadManager/UploadState.dart';
import 'package:smart_album/bloc/user/UserCubit.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/util/DialogUtil.dart';
import 'package:smart_album/widgets/LightAppBar.dart';
import 'package:smart_album/widgets/LoadingCircle.dart';
import 'package:tuple/tuple.dart';

class UploadList extends StatelessWidget {
  const UploadList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: LightAppBar(context, "Backup Manager"),
        body: Column(children: [
          SizedBox(
              height: 70,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                child: BlocBuilder<UploadCubit, UploadState>(
                    builder: (context, state) => Row(
                          children: [
                            Expanded(
                                child: Text("Enable auto backup",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white))),
                            Switch(
                              activeColor: Colors.white,
                              value: state.isUploadAll,
                              onChanged: (value) {
                                if (!context.read<UserCubit>().isLogin()) {
                                  showToast("Please login first");
                                  return;
                                }
                                context.read<PhotoCubit>().refresh(context);
                                if (value) {
                                  context.read<UploadCubit>().setAutoBackup();
                                  context.read<UploadCubit>().uploadPhotoList(
                                      context,
                                      context
                                          .read<PhotoCubit>()
                                          .state
                                          .photoListWithoutDeleted
                                          .where((photo) => !photo.isCloud)
                                          .toList());
                                } else
                                  DialogUtil.showConfirmDialog(
                                      context,
                                      "Waring",
                                      "Doing this will delete all photos in cloud.\nAre you sure?",
                                      () {
                                    context
                                        .read<UploadCubit>()
                                        .removeUploadedPhotoFromCloud(context);
                                    context.read<UploadCubit>().setAutoBackup();
                                    Navigator.of(context).pop();
                                  });
                              },
                            )
                          ],
                        )),
                decoration: BoxDecoration(color: Colors.blueAccent),
              )),
          Expanded(child:
              BlocBuilder<UploadCubit, UploadState>(builder: (context, state) {
            var photoList = state.uploadList.reversed.toList();
            return ListView.builder(
                itemCount: photoList.length,
                itemBuilder: (context, index) => ListTile(
                      onTap: () {},
                      title: Text(photoList[index].photo.name),
                      trailing:
                          photoList[index].status == UploadStatus.Uploading
                              ? LoadingCircle()
                              : Icon(Icons.check, color: Colors.green),
                    ));
          }))
        ]));
  }
}
