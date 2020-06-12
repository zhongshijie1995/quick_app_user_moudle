import 'dart:developer';

class UserModel {
  bool hasLogin;
  String avatar;
  String nick;
  String vip;
  String email;
  int themeIdx;
  int languageIdx;

  UserModel({
    this.hasLogin,
    this.avatar,
    this.nick,
    this.vip,
    this.email,
    this.themeIdx,
    this.languageIdx,
  });

  UserModel.fromJson(Map<String, dynamic> data) {
    log('从Json转换为UserModel');
    hasLogin = data['hasLogin'];
    avatar = data['avatar'];
    nick = data['nick'];
    vip = data['vip'];
    email = data['email'];
    themeIdx = data['themeIdx'];
    languageIdx = data['languageIdx'];
  }

  Map<String, dynamic> toJson() {
    log('将UserModel转为Json');
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasLogin'] = this.hasLogin;
    data['avatar'] = this.avatar;
    data['nick'] = this.nick;
    data['vip'] = this.vip;
    data['email'] = this.email;
    data['themeIdx'] = this.themeIdx;
    data['languageIdx'] = this.languageIdx;
    return data;
  }
}
