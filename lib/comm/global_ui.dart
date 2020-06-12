import 'dart:io';

import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickappuser/comm/global_txt.dart';
import 'package:quickappuser/state/change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class GlobalUi {
  static List<Color> colorList = [
    Color(0xFF0F4C81),
    Color(0xFFB22222),
  ];

  // 设置状态栏沉浸式
  static void overlaySetting() {
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

  // 弹出消息提示
  static void msgToast(BuildContext context, String msg) {
    Toast.show(
      msg,
      context,
      gravity: Toast.CENTER,
      duration: Toast.LENGTH_LONG,
    );
  }

  // 公共标题栏
  static Widget commonAppBar(
    BuildContext context,
    String subTitle,
    Widget leadingWidget,
    List<Widget> actionsWidgets,
  ) {
    // 默认Leading视图
    Widget defaultLeadingWidget;
    // 默认Action视图列表
    List<Widget> defaultActionsWidgets = [
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => Navigator.of(context).pushNamed('setting_page'),
      )
    ];
    UserModelNotifier userModelNotifier = Provider.of(context);
    return AppBar(
      centerTitle: true,
      title: FLAppBarTitle(
        title: GlobalTxt.txtTitle[userModelNotifier.languageIdx],
        subtitle: subTitle,
        subtitleStyle: TextStyle(fontSize: 12),
      ),
      leading: leadingWidget != null ? leadingWidget: defaultLeadingWidget,
      actions: actionsWidgets != null ? actionsWidgets : defaultActionsWidgets,
    );
  }

  // 获取
  static ThemeData getThemeData(int themeIdx) {
    return ThemeData(
      primaryColor: colorList[themeIdx],
    );
  }
}
