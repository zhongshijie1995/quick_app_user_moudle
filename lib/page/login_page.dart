import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:quickappuser/comm/global_tools.dart';
import 'package:quickappuser/comm/global_txt.dart';
import 'package:quickappuser/comm/global_ui.dart';
import 'package:quickappuser/state/change_notifier.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();
  GlobalKey<FormState> resetKey = new GlobalKey<FormState>();

  String username;
  String password;
  String email;

  bool isShowPassWord = false;
  bool loading = false;

  UserModelNotifier userModelNotifier;

  // 进行登录动作
  void _login() async {
    setState(() {
      loading = true;
    });

    var loginForm = loginKey.currentState;
    loginForm.save();

    username = username.trim();
    password = password.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      try {
        await LCUser.login(username.trim(), password.trim());
        LCUser user = await LCUser.getCurrent();
        LCObject currentUser = await LCQuery('_User').get(user.objectId);
        userModelNotifier.setUser = currentUser;
        userModelNotifier.setHasLogin = true;
      } on LCException catch (e) {
        GlobalUi.msgToast(context, GlobalTools.translateLCException(e));
      }
    } else {
      GlobalUi.msgToast(context, GlobalTxt.msgUsernamePasswordNotAllowNull[userModelNotifier.languageIdx]);
    }

    setState(() {
      loading = false;
    });
  }

  // 进行重置密码动作
  void _resetPassword() async {
    var resetKeyState = resetKey.currentState;
    resetKeyState.save();

    email = email.trim();

    // 验证邮箱格式
    if (!GlobalTools.isEmail(email)) {
      GlobalUi.msgToast(context, GlobalTxt.msgEmailNotCorrect[userModelNotifier.languageIdx]);
      return;
    }

    // 请求密码重置动作
    try {
      await LCUser.requestPasswordReset(email);
      GlobalUi.msgToast(context, GlobalTxt.msgResetEmailHasSend[userModelNotifier.languageIdx]);
    } on LCException catch (e) {
      GlobalUi.msgToast(context, GlobalTools.translateLCException(e));
    }
  }

  // 展示密码
  void showPassWord() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  @override
  Widget build(BuildContext context) {
    userModelNotifier = Provider.of(context);

    return Material(
      child: Scaffold(
        // 标题栏
        appBar: GlobalUi.commonAppBar(context, GlobalTxt.txtLogin[userModelNotifier.languageIdx], null, null),
        // 主体区域
        body: GestureDetector(
          // 点击空白区域收起聚焦
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          // 主要视图
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                // 登陆表单
                child: Form(
                  key: loginKey,
                  child: Column(
                    children: <Widget>[
                      // 用户名
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: GlobalTxt.txtUsername[userModelNotifier.languageIdx],
                          labelStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          username = value;
                        },
                      ),
                      // 密码
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: GlobalTxt.txtPassword[userModelNotifier.languageIdx],
                            labelStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isShowPassWord
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).hintColor,
                              ),
                              onPressed: showPassWord,
                            )),
                        obscureText: !isShowPassWord,
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                      // 登录按钮
                      Container(
                        height: 45,
                        margin: EdgeInsets.only(top: 40),
                        child: SizedBox.expand(
                          child: FLLoadingButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).canvasColor,
                            child: Text(GlobalTxt.txtLogin[userModelNotifier.languageIdx]),
                            loading: loading,
                            indicatorOnly: true,
                            onPressed: _login,
                          ),
                        ),
                      ),
                      // 其他选项
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'signup_page');
                              },
                              child: Text(GlobalTxt.txtSignup[userModelNotifier.languageIdx]),
                              textColor: Theme.of(context).hintColor,
                            ),
                            MaterialButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(GlobalTxt.txtEmail[userModelNotifier.languageIdx]),
                                        content: Form(
                                          key: resetKey,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              labelStyle: TextStyle(
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            ),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            onSaved: (value) {
                                              email = value;
                                            },
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FLFlatButton(
                                            textColor: Theme.of(context).primaryColor,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _resetPassword();
                                            },
                                            child: Text(
                                                GlobalTxt.txtResetPassword[userModelNotifier.languageIdx]),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text(GlobalTxt.txtForgetPassword[userModelNotifier.languageIdx]),
                              textColor: Theme.of(context).hintColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
