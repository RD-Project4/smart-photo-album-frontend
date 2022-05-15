import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class UrlTip extends StatelessWidget {
  final String url;

  const UrlTip({Key? key, required this.url}) : super(key: key);

  void _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) throw '无法打开 $_url';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 7,
              child: Text(
                url,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: url));
                      showToast('Link copied');
                    },
                    icon: Icon(
                      Icons.content_copy,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () async {
                      final Uri _url = Uri.parse(url);
                      if (!await launchUrl(_url)) throw '无法打开 $_url';
                    },
                    icon: Icon(Icons.open_in_new, color: Colors.white))
              ],
            ),
          ],
        ));
  }
}
