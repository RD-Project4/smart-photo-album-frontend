import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_album/util/ShareUtil.dart';

class ManageSharePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManageSharePageState();
}

class _ManageSharePageState extends State<ManageSharePage> {
  var recordList = [];

  @override
  void initState() {
    super.initState();

    var _fakeData = [];

    for (var i = 0; i < 20; i++) {
      _fakeData.add({
        "link": "www.baidu.com",
        "time": DateTime.now(),
      });
    }

    setState(() {
      recordList = _fakeData;
    });
  }

  Widget _buildRecord(String link, DateTime time) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              "www.baidu.com",
              overflow: TextOverflow.ellipsis,
            ),
            flex: 7,
          ),
          IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: link));
              showToast("Link copied");
            },
          ),
          IconButton(
            icon: Icon(Icons.qr_code_2),
            onPressed: () {
              ShareUtil.showLink(context, link);
            },
          ),
          ElevatedButton(
            onPressed: () {
              Dialogs.materialDialog(
                  msg: "Are you sure you want to cancel sharing? you can\'t undo this",
                  title: "Cancel Sharing",
                  color: Colors.white,
                  context: context,

                  actions: [
                    IconsOutlineButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: 'No',
                      iconData: Icons.cancel_outlined,
                      textStyle: TextStyle(color: Colors.grey),
                      iconColor: Colors.grey,
                    ),
                    IconsButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: 取消分享
                      },
                      text: 'Confirm',
                      iconData: Icons.delete,
                      color: Colors.red,
                      textStyle: TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
                  ]);
            },
            child: Text("Cancel"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
          ),
        ],
      ),
      subtitle: Text(DateFormat('yyyy-MM-dd  kk:mm').format(time)),
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
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          var record = recordList[index];
          return _buildRecord(record["link"], record["time"]);
        },
        itemCount: recordList.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1.0, color: Colors.grey),
      ),
    );
  }
}
