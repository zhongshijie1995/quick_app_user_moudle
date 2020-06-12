import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:quickappuser/comm/global_tools.dart';
import 'package:quickappuser/comm/global_txt.dart';
import 'package:quickappuser/comm/global_ui.dart';
import 'package:quickappuser/state/change_notifier.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> signUpKey = new GlobalKey<FormState>();

  String username;
  String password;
  String passwordAgain;

  bool isShowPassword = false;
  bool isShowPasswordAgain = false;

  UserModelNotifier userModelNotifier;

  // 进行注册动作
  Future<void> signUp() async {
    var loginForm = signUpKey.currentState;
    loginForm.save();

    username = username.trim();
    password = password.trim();
    passwordAgain = passwordAgain.trim();

    if (username.isEmpty || password.isEmpty || passwordAgain.isEmpty) {
      GlobalUi.msgToast(
          context,
          GlobalTxt
              .msgUsernamePasswordNotAllowNull[userModelNotifier.languageIdx]);
      return;
    }

    if (password != passwordAgain) {
      GlobalUi.msgToast(
          context, GlobalTxt.msgPasswordNotSame[userModelNotifier.languageIdx]);
      return;
    }

    try {
      LCUser user = LCUser();
      user.username = username;
      user.password = password;
      user.signUp();
      GlobalUi.msgToast(
          context, GlobalTxt.msgSignupSucc[userModelNotifier.languageIdx]);
      Navigator.pop(context);
    } on LCException catch (e) {
      GlobalUi.msgToast(context, GlobalTools.translateLCException(e));
    }
  }

  // 展示密码
  void showPassWord() {
    setState(() {
      isShowPassword = !isShowPassword;
    });
  }

  // 展示确认密码
  void showPassWordAgain() {
    setState(() {
      isShowPasswordAgain = !isShowPasswordAgain;
    });
  }

  @override
  Widget build(BuildContext context) {
    userModelNotifier = Provider.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        child: Scaffold(
          appBar: GlobalUi.commonAppBar(context,
              GlobalTxt.txtSignup[userModelNotifier.languageIdx], null, null),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: signUpKey,
                      child: Column(
                        children: <Widget>[
                          // 用户名
                          Container(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: GlobalTxt
                                    .txtUsername[userModelNotifier.languageIdx],
                                labelStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              onSaved: (value) {
                                username = value;
                              },
                            ),
                          ),
                          // 密码
                          Container(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: GlobalTxt.txtPassword[
                                      userModelNotifier.languageIdx],
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).hintColor,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isShowPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    onPressed: showPassWord,
                                  )),
                              obscureText: !isShowPassword,
                              onSaved: (value) {
                                password = value;
                              },
                            ),
                          ),
                          // 确认密码
                          Container(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: GlobalTxt.txtPasswordAgain[
                                      userModelNotifier.languageIdx],
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).hintColor,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isShowPasswordAgain
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    onPressed: showPassWordAgain,
                                  )),
                              obscureText: !isShowPasswordAgain,
                              onSaved: (value) {
                                passwordAgain = value;
                              },
                            ),
                          ),
                          // 登录按钮
                          Container(
                            height: 45,
                            margin: EdgeInsets.only(top: 40),
                            child: SizedBox.expand(
                              child: FLLoadingButton(
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context).canvasColor,
                                onPressed: signUp,
                                child: Text(
                                  GlobalTxt
                                      .txtSignup[userModelNotifier.languageIdx],
                                ),
                              ),
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
        ),
      ),
    );
  }
}
