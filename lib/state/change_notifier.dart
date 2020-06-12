import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:quickappuser/comm/global_params.dart';
import 'package:quickappuser/model/user_model.dart';

class AppChangeNotifier extends ChangeNotifier {
  UserModel get _userModel => GlobalParams.userModel;

  @override
  void notifyListeners() {
    GlobalParams.saveUserModel();
    super.notifyListeners();
  }
}

class UserModelNotifier extends AppChangeNotifier {
  bool get hasLogin =>
      _userModel.hasLogin == null? false : _userModel.hasLogin;
  String get avatar => _userModel.avatar;
  String get nick => _userModel.nick;
  String get vip => _userModel.vip;
  String get email => _userModel.email == null? '': _userModel.email;
  int get themeIdx => _userModel.themeIdx == null? 0: _userModel.themeIdx;
  int get languageIdx => _userModel.languageIdx == null? 0: _userModel.languageIdx;

  set setHasLogin(bool hasLogin) {
    _userModel.hasLogin = hasLogin;
    notifyListeners();
  }

  set setAvatar(String avatar) {
    _userModel.avatar = avatar;
    notifyListeners();
  }

  set setNick(String nick) {
    _userModel.nick = nick;
    notifyListeners();
  }

  set setVip(String vip) {
    _userModel.vip = vip;
    notifyListeners();
  }

  set setEmail(String vip) {
    _userModel.email = email;
    notifyListeners();
  }

  set setUser(LCObject lcObject) {
    if (lcObject['emailVerified']) {
      _userModel.email = lcObject['email'];
    }
    _userModel.avatar = lcObject['avatar'];
    _userModel.nick = lcObject['nick'];
    _userModel.vip = lcObject['vip'];
    notifyListeners();
  }

  set setThemeIdx(int themeIdx) {
    _userModel.themeIdx = themeIdx;
    notifyListeners();
  }

  set setLanguageIdx(int lanuageIdx) {
    _userModel.languageIdx = lanuageIdx;
    notifyListeners();
  }
}
