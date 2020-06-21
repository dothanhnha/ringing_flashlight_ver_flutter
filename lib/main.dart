import 'dart:ffi';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ringing_flashlight/AndroidPlarform.dart';
import 'package:ringing_flashlight/ScreenAdvanceSetting.dart';
import 'package:ringing_flashlight/ScreenHome.dart';
import 'package:ringing_flashlight/SharePre.dart';

import 'ScreenCall.dart';
import 'ScreenNotif.dart';
import 'ScreenMessage.dart';

void main() {
  runApp(MaterialApp(home: ScreenHome(), routes: {
    '/callScreen': (context) => ScreenCall(),
    '/notifScreen': (context) => ScreenNotif(),
    '/messageScreen': (context) => ScreenMessage(),
    '/advanceSettingScreen': (context) => ScreenAdvanceSetting(),
  }));
}

class General {

  static void showDialogSetting(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Notification!"),
          content: new Text("Ringing FlashLight need you grant permission."),
          actions: <Widget>[
            FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("Setting"),
              onPressed: () {
                Navigator.of(context).pop();
                AndroidPlatform.openSettingActivity().then((value){
                  print('close setting');
                });
              },
            ),
          ],
        );
      },
    );
  }
}
