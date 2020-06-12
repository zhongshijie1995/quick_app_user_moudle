import 'package:flutter/material.dart';
import 'package:quickappuser/comm/global_params.dart';
import 'package:quickappuser/comm/global_ui.dart';
import 'package:quickappuser/page/home_page.dart';
import 'package:quickappuser/page/login_page.dart';
import 'package:quickappuser/page/setting_page.dart';
import 'package:quickappuser/page/signup_page.dart';
import 'package:quickappuser/state/change_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  // 设置全局沉浸式状态栏
  GlobalUi.overlaySetting();

  // 初始化全局变量，运行App
  GlobalParams.init().then((value) => runApp(App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // 状态管理器
      providers: [
        ChangeNotifierProvider.value(value: UserModelNotifier()),
      ],
      // 状态消费者
      child: Consumer<UserModelNotifier>(
        builder: (BuildContext context, userModelNotifier, Widget child) {
          return MaterialApp(
            theme: GlobalUi.getThemeData(userModelNotifier.themeIdx),
            darkTheme: ThemeData.dark(),
            home: userModelNotifier.hasLogin ? HomePage() : LoginPage(),
            routes: <String, WidgetBuilder>{
              'login_page': (context) => LoginPage(),
              'signup_page': (context) => SignUpPage(),
              'home_page': (context) => HomePage(),
              'setting_page': (context) => SettingPage(),
            },
          );
        },
      ),
    );
  }
}
