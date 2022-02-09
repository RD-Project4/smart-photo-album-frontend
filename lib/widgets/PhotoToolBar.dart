import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_album/PhotoEditPage.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';

class PhotoToolBar extends StatelessWidget {
  final photoIndex;

  const PhotoToolBar({Key? key, required this.photoIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(128, 128, 128, 128),
      height: 70,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconText(
              icon: Icons.share,
              text: "Share",
              onTap: () {
                // Fluttertoast.showToast(msg: "Share");
                _openShareBottomSheet(context, 1);
              }),
          IconText(
              icon: Icons.edit,
              text: "Edit",
              onTap: () {
                var photos =
                    BlocProvider.of<PhotoListCubit>(context).state.photos;
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PhotoEditPage(
                    entity: photos[photoIndex],
                  );
                }));
              }),
          IconText(icon: Icons.favorite_border, text: "Favorite"),
          IconText(icon: Icons.delete, text: "Delete")
        ],
      ),
    );
  }

  Future _openShareBottomSheet(BuildContext context, int photoNum) async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      text: 'Share ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: '$photoNum',
                            style: TextStyle(color: Colors.blueAccent)),
                        TextSpan(
                            text: ' photo${photoNum > 1 ? 's' : ''} with:'),
                      ],
                    ),
                  ),
                  // title: RichText(
                  //   text: TextSpan(text: ),'Share $photoNum photo${photoNum > 1 ? 's' : ''} with:',
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  // ),
                ),
                ListTile(
                  title: Text('Everyone', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '分享给所有人');
                  },
                ),
                ListTile(
                  title: Text('Only my friends', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '只分享给朋友');
                  },
                ),
                ListTile(
                  title: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context, '取消');
                  },
                ),
              ],
            ),
          );
        });

    print(option);
  }
}

class IconText extends StatelessWidget {
  final icon, text, onTap;

  IconText(
      {Key? key,
      required this.icon,
      required this.text,
      void Function()? this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
