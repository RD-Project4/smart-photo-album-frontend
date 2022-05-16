import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:smart_album/api/api.dart';
import 'package:smart_album/model/Share.dart';
import 'package:smart_album/util/DialogUtil.dart';
import 'package:smart_album/util/ShareUtil.dart';
import 'package:smart_album/widgets/LoadingCircle.dart';

class ManageSharePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManageSharePageState();
}

class _ManageSharePageState extends State<ManageSharePage> {
  List<Share>? recordList;

  refreshShare() {
    Api.get().getShareList().then((shareList) => setState(() {
          recordList = shareList;
        }));
  }

  @override
  void initState() {
    super.initState();
    refreshShare();
  }

  Widget _buildRecord(Share share) {
    return ListTile(
      onTap: () {
        ShareUtil.showLink(context, share.getShareLink());
      },
      title: Row(
        children: [
          Expanded(
            child: Text(
              share.userIdList.join(","),
              overflow: TextOverflow.ellipsis,
            ),
            flex: 7,
          ),
          IconButton(
            icon: Icon(Icons.copy_outlined),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: share.getShareLink()));
              showToast("Link copied");
            },
          ),
          ElevatedButton(
            onPressed: () {
              DialogUtil.showConfirmDialog(context, "Revoke Sharing",
                  "Are you sure you want to revoke sharing? You can\'t undo this",
                  () async {
                await Api.get().deleteShare(share);
                Navigator.pop(context);
                refreshShare();
              });
            },
            child: Text("Revoke"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Share",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
      ),
      body: recordList != null
          ? ListView.separated(
              itemBuilder: (context, index) {
                var share = recordList![index];
                return _buildRecord(share);
              },
              itemCount: recordList!.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 1.0, color: Colors.grey),
            )
          : SizedBox.expand(child: Center(child: LoadingCircle())),
    );
  }
}
