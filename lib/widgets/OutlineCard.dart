import 'package:flutter/material.dart';

class OutlineCard extends StatelessWidget {
  final EdgeInsets? margin;
  final String title;
  final String? subTitle;
  final Widget? child;

  const OutlineCard(
      {Key? key, this.margin, required this.title, this.subTitle, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SizedBox(
        width: double.infinity,
        child: Semantics(
            container: true,
            child: Container(
              margin: margin,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    child ?? Container(),
                  ]),
            )));
  }
}
