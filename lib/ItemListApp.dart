import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:ringing_flashlight/ScreenNotif.dart';

class ItemListApp extends StatefulWidget {
  AppWithCheck appWithCheck;

  @override
  _ItemListAppState createState() => _ItemListAppState(appWithCheck);

  ItemListApp(this.appWithCheck);
}

class _ItemListAppState extends State<ItemListApp> {
  AppWithCheck appWithCheck;

  _ItemListAppState(this.appWithCheck);

  @override
  Widget build(BuildContext context) {
    ApplicationWithIcon app = appWithCheck.app;
    return ListTile(
      onTap: () {
        setState(() {
          appWithCheck.isChecked = !(appWithCheck.isChecked);
        });
      },
      leading: Image.memory(app.icon, gaplessPlayback: true),
      title: Text(app.appName),
      trailing: Checkbox(
        value: appWithCheck.isChecked,
        onChanged: (value) {
          setState(() {
            appWithCheck.isChecked = !(appWithCheck.isChecked);
          });
        },
      ),
    );
  }
}
