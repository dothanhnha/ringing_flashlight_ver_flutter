import 'package:flutter/services.dart';
import 'package:ringing_flashlight/SharePre.dart';

class AndroidPlatform {
  static const channelService =
      const MethodChannel('samples.flutter.dev/service');
  static final String FIELD_ACTION = "FIELD_ACTION";
  static final String CALL_ACTION = "android.intent.action.PHONE_STATE";
  static final String SMS_ACTION = "android.provider.Telephony.SMS_RECEIVED";
  static final String FIELD_IS_ACTIVE = "FIELD_IS_ACTIVE";

  static void startService(String action, bool isActive) {
    channelService
        .invokeMethod('runService', {'action': action, 'isActive': isActive});
  }

  static void pushDataUserToService(String key){
    List<String> keySplited = key.split('_');
    switch (keySplited[0]) {
      case 'S':
        channelService.invokeMethod('pushDataUserToService',
            {'key': key, 'value': SharePre.sharedPreferences.getString(key)});
        break;
      case 'B':
        channelService.invokeMethod('pushDataUserToService', {
          'key': key,
          'value': SharePre.sharedPreferences.getBool(key).toString()
        });
        break;
      case 'I':
        channelService.invokeMethod('pushDataUserToService', {
          'key': key,
          'value': SharePre.sharedPreferences.getInt(key).toString()
        });
        break;
      case 'D':
        channelService.invokeMethod('pushDataUserToService', {
          'key': key,
          'value': SharePre.sharedPreferences.getDouble(key).toString()
        });
        break;
      case 'SL':
        List<String> list = SharePre.sharedPreferences.getStringList(key);
        if (list != null) {
          for (int i = 0; i < list.length; i++) {
            channelService.invokeMethod('pushDataUserToService',
                {'key': key + "_" + i.toString(), 'value': list[i]});
          }
        }
        break;
    }
  }

  static Future<void> openSettingActivity(){
    return channelService
        .invokeMethod('openSettingActivity');
  }

  static Future<bool> checkIsFromSettingActivity(){
    return channelService
        .invokeMethod('checkIsfromSettingActivity');
  }

  static void pushAllDataUserToService() {
    for (String key in SharePre.listKey) {
      pushDataUserToService(key);
    }
  }
}
