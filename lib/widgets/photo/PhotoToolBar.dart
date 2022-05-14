import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:oktoast/oktoast.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/bloc/photo/PhotoState.dart';
import 'package:smart_album/bloc/uploadManager/UploadCubit.dart';
import 'package:smart_album/bloc/user/UserCubit.dart';
import 'package:smart_album/bloc/user/UserState.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/pages/photo_edit_page/PhotoEditPage.dart';
import 'package:smart_album/util/ShareUtil.dart';
import 'package:smart_album/widgets/TensorflowResultPanel.dart';
import 'package:material_dialogs/material_dialogs.dart';

class PhotoToolBar extends StatefulWidget {
  final Photo photo;

  const PhotoToolBar({Key? key, required this.photo}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoToolBarState();
}

class _PhotoToolBarState extends State<PhotoToolBar> {
  @override
  Widget build(BuildContext context) {
    Photo photo = widget.photo;

    return BlocBuilder<PhotoCubit, PhotoState>(
        builder: (context, state) => Container(
              height: 70,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconText(
                    icon: Icons.search_outlined,
                    text: "Similar",
                    onTap: () {
                      TensorflowResultPanel.open(context, photo);
                    },
                  ),
                  IconText(
                      icon: Icons.share_outlined,
                      text: "Share",
                      onTap: () {
                        ShareUtil.openShareBottomSheet(context, 1);
                      }),
                  IconText(
                      icon: Icons.edit_outlined,
                      text: "Edit",
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PhotoEditPage(
                            entity: photo,
                          );
                        }));
                      }),
                  !photo.isCloud
                      ? IconText(
                          icon: Icons.file_upload_outlined,
                          text: "Upload",
                          onTap: () {
                            if (context.read<UserCubit>().isLogin()) {
                              context
                                  .read<UploadCubit>()
                                  .uploadPhoto(context, photo);
                              showToast(
                                  'Uploading in the background, please check status in the backup manager');
                            } else
                              showToast('Please login first');
                          },
                        )
                      : IconText(
                          icon: Icons.cloud_done_outlined, text: "In cloud"),
                  IconText(
                    icon: photo.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: photo.isFavorite ? Colors.red : null,
                    text: "Favorite",
                    onTap: () {
                      context
                          .read<PhotoCubit>()
                          .markOrUnMarkPhotoAsFavorite(photo);
                    },
                  ),
                  // IconText(
                  //   icon: Icons.delete,
                  //   text: "Delete",
                  //   onTap: () {},
                  // )
                ],
              ),
            ));
  }
}

class IconText extends StatelessWidget {
  final icon, text, onTap, color;

  IconText(
      {Key? key,
      required this.icon,
      required this.text,
      Color? this.color,
      void Function()? this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color != null ? color : Colors.black,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

class CopyBtn extends StatefulWidget {
  final String text;

  CopyBtn({Key? key, required this.text}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CopyBtnState();
}

class _CopyBtnState extends State<CopyBtn> {
  var hasCopied = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: widget.text));
          setState(() {
            hasCopied = true;
          });
        },
        child: Text(hasCopied ? 'Copied' : 'Copy'));
  }
}
