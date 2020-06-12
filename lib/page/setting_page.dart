import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:quickappuser/comm/global_tools.dart';
import 'package:quickappuser/comm/global_txt.dart';
import 'package:quickappuser/comm/global_ui.dart';
import 'package:quickappuser/state/change_notifier.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  UserModelNotifier userModelNotifier;

  GlobalKey<FormState> settingKey = new GlobalKey<FormState>();

  String avatar;
  String nick;
  String email;

  @override
  Widget build(BuildContext context) {
    userModelNotifier = Provider.of(context);
    return Material(
      child: Scaffold(
          appBar: GlobalUi.commonAppBar(
            context,
            GlobalTxt.txtUserSetting[userModelNotifier.languageIdx],
            null,
            [],
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: FLStaticListView(
              shrinkWrap: true,
              sections: _settingList(),
            ),
          )),
    );
  }

  // 设置列表
  List<FLStaticSectionData> _settingList() {
    List<FLStaticSectionData> result = List<FLStaticSectionData>();
    if (userModelNotifier.hasLogin) {
      result.add(
        FLStaticSectionData(
          headerTitle: GlobalTxt.txtAccount[userModelNotifier.languageIdx],
          itemList: [
            FLStaticItemData(
              title: GlobalTxt.txtAvatar[userModelNotifier.languageIdx],
              customTrailing: userModelNotifier.avatar != null
                  ? FLAvatar(
                      image: Image.network(userModelNotifier.avatar),
                      color: Theme.of(context).primaryColor,
                      width: 40,
                      height: 40,
                    )
                  : FLAvatar(
                      text: userModelNotifier.nick,
                      color: Theme.of(context).primaryColor,
                      textStyle:
                          TextStyle(color: Theme.of(context).canvasColor),
                      width: 40,
                      height: 40,
                    ),
              onTap: _setAvatar,
            ),
            FLStaticItemData(
              title: GlobalTxt.txtNick[userModelNotifier.languageIdx],
              accessoryType: FLStaticListCellAccessoryType.accDetail,
              accessoryString: userModelNotifier.nick,
              onTap: _setNick,
            ),
            FLStaticItemData(
              title: GlobalTxt.txtEmail[userModelNotifier.languageIdx],
              accessoryType: FLStaticListCellAccessoryType.accDetail,
              accessoryString: userModelNotifier.email,
              onTap: _setEmail,
            ),
            FLStaticItemData(
              title: GlobalTxt.txtVip[userModelNotifier.languageIdx],
              accessoryType: FLStaticListCellAccessoryType.accDetail,
              accessoryString: userModelNotifier.vip,
              onTap: _setVip,
            ),
          ],
        ),
      );
    }
    result.add(
      FLStaticSectionData(
        headerTitle: GlobalTxt.txtAppearance[userModelNotifier.languageIdx],
        itemList: [
          FLStaticItemData(
            title: GlobalTxt.txtTheme[userModelNotifier.languageIdx],
            accessoryType: FLStaticListCellAccessoryType.accDetail,
            accessoryString:
                GlobalTxt.txtThemeList[userModelNotifier.languageIdx]
                    [userModelNotifier.themeIdx],
            onTap: _setTheme,
          ),
          FLStaticItemData(
            title: GlobalTxt.txtLanguage[userModelNotifier.languageIdx],
            accessoryType: FLStaticListCellAccessoryType.accDetail,
            accessoryString:
                GlobalTxt.txtlanguageList[userModelNotifier.languageIdx],
            onTap: _setLanguage,
          ),
        ],
      ),
    );
    if (userModelNotifier.hasLogin) {
      result.add(
        FLStaticSectionData(
          itemList: [
            FLStaticItemData(
              cellType: FLStaticListCellType.button,
              buttonTitle: GlobalTxt.txtSync[userModelNotifier.languageIdx],
              buttonTitleColor: Colors.blue,
              onButtonPressed: _refreshUserMoel,
            ),
            FLStaticItemData(
              cellType: FLStaticListCellType.button,
              buttonTitle: GlobalTxt.txtLogout[userModelNotifier.languageIdx],
              buttonTitleColor: Colors.red,
              onButtonPressed: _logout,
            ),
          ],
        ),
      );
    }
    return result;
  }

  // 获取语言选项
  FLStaticSectionData _getLanguageItem() {
    List<FLStaticItemData> result = List<FLStaticItemData>();
    for (var i = 0; i < GlobalTxt.txtlanguageList.length; i++) {
      result.add(
        FLStaticItemData(
          title: GlobalTxt.txtlanguageList[i],
          accessoryType: FLStaticListCellAccessoryType.accCheckmark,
          onTap: () {
            userModelNotifier.setLanguageIdx = i;
          },
          selected: userModelNotifier.languageIdx == i,
        ),
      );
    }
    return FLStaticSectionData(
      headerTitle: GlobalTxt.txtLanguage[userModelNotifier.languageIdx],
      itemList: result,
    );
  }

  // 获取主题选项
  FLStaticSectionData _getThemeItem() {
    List<FLStaticItemData> result = List<FLStaticItemData>();
    for (var i = 0; i < GlobalUi.colorList.length; i++) {
      result.add(
        FLStaticItemData(
          title: GlobalTxt.txtThemeList[userModelNotifier.languageIdx][i],
          accessoryType: FLStaticListCellAccessoryType.accCheckmark,
          onTap: () {
            userModelNotifier.setThemeIdx = i;
          },
          selected: userModelNotifier.themeIdx == i,
        ),
      );
    }
    return FLStaticSectionData(
        headerTitle: GlobalTxt.txtTheme[userModelNotifier.languageIdx],
        itemList: result);
  }

  // 设置头像
  void _setAvatar() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(GlobalTxt.txtAvatar[userModelNotifier.languageIdx]),
            content: Form(
              key: settingKey,
              child: TextFormField(
                initialValue: userModelNotifier.avatar.toString(),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                keyboardType: TextInputType.text,
                onSaved: (value) {
                  avatar = value;
                },
              ),
            ),
            actions: <Widget>[
              FLFlatButton(
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                  _updateAvatar();
                },
                child: Text(GlobalTxt.txtFinish[userModelNotifier.languageIdx]),
              ),
            ],
          );
        });
  }

  // 设置昵称
  void _setNick() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(GlobalTxt.txtNick[userModelNotifier.languageIdx]),
            content: Form(
              key: settingKey,
              child: TextFormField(
                initialValue: userModelNotifier.nick.toString(),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                keyboardType: TextInputType.text,
                onSaved: (value) {
                  nick = value;
                },
              ),
            ),
            actions: <Widget>[
              FLFlatButton(
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                  _updateNick();
                },
                child: Text(GlobalTxt.txtFinish[userModelNotifier.languageIdx]),
              ),
            ],
          );
        });
  }

  // 设置电子邮件
  void _setEmail() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(GlobalTxt.txtEmail[userModelNotifier.languageIdx]),
            content: Form(
              key: settingKey,
              child: TextFormField(
                initialValue: userModelNotifier.email.toString(),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
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
                  _updateEmail();
                },
                child: Text(GlobalTxt.txtFinish[userModelNotifier.languageIdx]),
              ),
            ],
          );
        });
  }

  // 设置会员
  void _setVip() {}

  // 设置语言
  void _setLanguage() {
    showFLBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FLCupertinoActionSheet(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FLStaticListView(
                    shrinkWrap: true,
                    sections: [_getLanguageItem()],
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                GlobalTxt.txtCancel[userModelNotifier.languageIdx],
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            style: FLCupertinoActionSheetStyle.filled,
          );
        }).then((value) {
      print(value);
    });
  }

  // 设置主题
  void _setTheme() {
    showFLBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FLCupertinoActionSheet(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FLStaticListView(
                    shrinkWrap: true,
                    sections: [_getThemeItem()],
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                GlobalTxt.txtCancel[userModelNotifier.languageIdx],
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            style: FLCupertinoActionSheetStyle.filled,
          );
        }).then((value) {
      print(value);
    });
  }

  // 更新用户持久化数据
  void _refreshUserMoel() async {
    LCUser user = await LCUser.getCurrent();
    LCObject currentUser = await LCQuery('_User').get(user.objectId);
    userModelNotifier.setUser = currentUser;
  }

  // 退出登录
  void _logout() async {
    Navigator.pop(context);
    await LCUser.logout();
    userModelNotifier.setHasLogin = false;
  }

  // 更新头像
  void _updateAvatar() async {
    var settingForm = settingKey.currentState;
    settingForm.save();
    avatar = avatar.trim();
    if (avatar.isEmpty) {
      return;
    }
    if (avatar == userModelNotifier.avatar) {
      return;
    }
    try {
      LCUser user = await LCUser.getCurrent();
      user['avatar'] = avatar;
      user.save();
      userModelNotifier.setAvatar = avatar;
    } on LCException catch (e) {
      GlobalUi.msgToast(context, GlobalTools.translateLCException(e));
    }
  }

  // 更新电子邮箱
  void _updateEmail() async {
    var settingForm = settingKey.currentState;
    settingForm.save();
    email = email.trim();
    try {
      LCUser user = await LCUser.getCurrent();
      LCObject userQuery = await LCQuery('_User').get(user.objectId);

      if (!GlobalTools.isEmail(email)) {
        GlobalUi.msgToast(context,
            GlobalTxt.msgEmailNotCorrect[userModelNotifier.languageIdx]);
        return;
      }

      if (userQuery['emailVerified'] && userQuery['email'] == email) {
        GlobalUi.msgToast(context,
            GlobalTxt.msgEmailHasVerify[userModelNotifier.languageIdx]);
        return;
      }

      user.email = email;
      user.save();
      GlobalUi.msgToast(context,
          GlobalTxt.msgVerifyEmailHasSend[userModelNotifier.languageIdx]);
    } on LCException catch (e) {
      GlobalUi.msgToast(context, GlobalTools.translateLCException(e));
    }
  }

  // 更新昵称
  void _updateNick() async {
    var settingForm = settingKey.currentState;
    settingForm.save();
    nick = nick.trim();
    if (nick.isEmpty) {
      return;
    }
    if (nick == userModelNotifier.avatar) {
      return;
    }
    try {
      LCUser user = await LCUser.getCurrent();
      user['nick'] = nick;
      user.save();
      userModelNotifier.setNick = nick;
    } on LCException catch (e) {
      GlobalUi.msgToast(context, GlobalTools.translateLCException(e));
    }
  }
}
