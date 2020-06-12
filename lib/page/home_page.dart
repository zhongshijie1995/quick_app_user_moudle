import 'package:flutter/material.dart';
import 'package:quickappuser/state/change_notifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModelNotifier userModelNotifier;

  @override
  Widget build(BuildContext context) {
    userModelNotifier = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("主页"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, 'setting_page');
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hello, Demo',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userModelNotifier.setLanguageIdx = 1;
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
