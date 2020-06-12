import 'package:leancloud_storage/leancloud.dart';

class GlobalTools {
  // 判断输入是否邮箱格式
  static bool isEmail(String input) {
    String regexEmail = '^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$';
    if (input == null || input.isEmpty) {
      return false;
    }
    return new RegExp(regexEmail).hasMatch(input);
  }

  // 翻译LeanCloud异常消息
  static String translateLCException(LCException e) {
    return '${e.code.toString()}: ${e.message}';
  }
}
