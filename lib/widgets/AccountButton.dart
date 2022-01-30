import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../LoginPage.dart';
import '../widgets/Form.dart';

class AccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularButton(
      icon: const Icon(Icons.account_circle_outlined),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
  }
}
