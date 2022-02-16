import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:smart_album/util/Global.dart';

import '../pages/user/LoginPage.dart';
import '../widgets/Form.dart';

@Deprecated("搜索栏不再提供跳转到登录页的功能")
class AccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularButton(
      icon: const Icon(Icons.account_circle_outlined),
      onPressed: () {
        Global.tabsKey.currentState?.openEndDrawer();
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
  }
}
