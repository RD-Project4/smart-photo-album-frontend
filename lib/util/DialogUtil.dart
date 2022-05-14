import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:tuple/tuple.dart';

class DialogUtil {
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    bool barrierDismissible = true,
    required WidgetBuilder builder,
    ThemeData? theme,
  }) {
    final ThemeData theme = Theme.of(context);
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(builder: builder);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return theme != null
                ? Theme(data: theme, child: pageChild)
                : pageChild;
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black87,
      // 自定义遮罩颜色
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
  }

  static Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // 使用缩放动画
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  static showConfirmDialog(BuildContext context, String title, String content,
      void Function() onConfirm) {
    Dialogs.materialDialog(
        msg: content,
        title: title,
        color: Colors.white,
        context: context,
        lottieBuilder:
            LottieBuilder.asset('assets/animation/alert.json', repeat: false),
        actions: [
          IconsOutlineButton(
            onPressed: () => Navigator.of(context).pop(),
            text: 'Cancel',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: onConfirm,
            text: 'Yes',
            iconData: Icons.delete,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  static showSelectFromListDialog(
      BuildContext context,
      String title,
      String content,
      Tuple2<String, String> options,
      void Function(int) onSelect) {
    Dialogs.materialDialog(
        context: context,
        msg: content,
        title: title,
        color: Colors.white,
        lottieBuilder:
            LottieBuilder.asset('assets/animation/alert.json', repeat: false),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconsButton(
                onPressed: () => onSelect(0),
                text: options.item1,
                color: Colors.blueAccent,
                textStyle: TextStyle(color: Colors.white),
              ),
              IconsButton(
                onPressed: () => onSelect(1),
                text: options.item2,
                color: Colors.blueAccent,
                textStyle: TextStyle(color: Colors.white),
              ),
              IconsButton(
                onPressed: () => Navigator.of(context).pop(),
                text: 'Cancel',
                iconData: Icons.cancel_outlined,
                textStyle: TextStyle(color: Colors.grey),
              ),
            ],
          )
        ]);
  }

  static showWarningDialog(BuildContext context, String title, String content) {
    Dialogs.materialDialog(
      context: context,
      msg: content,
      title: title,
      color: Colors.white,
      lottieBuilder:
          LottieBuilder.asset('assets/animation/alert.json', repeat: false),
    );
  }
}
