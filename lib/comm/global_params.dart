import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:quickappuser/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalParams {
  static SharedPreferences _prefs;

  static UserModel userModel = UserModel();

  static String appId = 'AppID';
  static String appKey = 'AppKey';
  static String serverUrl = 'REST API 服务器地址';

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // 获取数据持久化实例
    _prefs = await SharedPreferences.getInstance();
    // 初始化云端数据存储
    LeanCloud.initialize(
      appId,
      appKey,
      server: serverUrl,
      queryCache: new LCQueryCache(),
    );
    LCLogger.setLevel(LCLogger.OffLevel);

    // 获取UserModel数据
    var userModelPrefs = _prefs.getString('UserModel');
    if (userModelPrefs != null) {
      try {
        log('从SharedPreferences读取到UserModel');
        userModel = UserModel.fromJson(jsonDecode(userModelPrefs));
      } catch (e) {
        log(e);
      }
    }
  }

  static saveUserModel() {
    log('将UserModel存入SharedPreferences');
    _prefs.setString("UserModel", jsonEncode(userModel));
  }
}
