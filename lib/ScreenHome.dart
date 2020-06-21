import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ringing_flashlight/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torch_compat/torch_compat.dart';
import 'AndroidPlarform.dart';
import 'DTNSwitch.dart';
import 'SharePre.dart';

class ScreenHome extends StatefulWidget {
  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> with WidgetsBindingObserver {
  AssetImage buttonImage;
  AssetImage buttonImageOn;
  AssetImage buttonImageOff;
  AssetImage lightOn = AssetImage("assets/light_on.png");
  AssetImage lightOff = AssetImage("assets/light_off.png");
  bool isLightOn;
  bool incomingCallMode;
  bool notifMode;
  bool messageMode;
  bool isOpenDialogSetting = false;
  TextStyle styleTitleMenu;

  double elevation = 10;


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

//    if(state == AppLifecycleState.resumed && ){
//      Permission.phone.isGranted.then((isGranted){
//        print('checked');
//        setState(() {
//          incomingCallMode = true;
//        });
//        AndroidPlatform.startService(AndroidPlatform.CALL_ACTION, true);
//        SharePre.sharedPreferences.setBool(
//            SharePre.INCOMING_CALL_MODE, true);
//        AndroidPlatform.pushDataUserToService(SharePre.INCOMING_CALL_MODE);
//      });
//
//
//      Permission.sms.isGranted.then((isGranted){
//        setState(() {
//          messageMode = true;
//        });
//        AndroidPlatform.startService(AndroidPlatform.SMS_ACTION, true);
//        SharePre.sharedPreferences.setBool(
//            SharePre.MESSAGE_MODE, true);
//        AndroidPlatform.pushDataUserToService(SharePre.MESSAGE_MODE);
//      });
//      isOpenDialogSetting = false;
//    }

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    buttonImageOn = AssetImage("assets/light_on.png");
    buttonImageOff = AssetImage("assets/light_off.png");
    buttonImage = buttonImageOff;
    isLightOn = false;
    styleTitleMenu = TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);

  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies()  call");
    precacheImage(AssetImage("assets/light_on.png"), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    if (SharePre.sharedPreferences == null)
      return FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              SharePre.sharedPreferences = snapshot.data;
              initData();
              return screenShow();
            } else {
              return Scaffold(
                backgroundColor: Colors.yellow[300],
                body: Center(
                  child: SpinKitRing(
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              );
            }
          });
    else {
      print('screenShow');
      return screenShow();
    }
  }

  Widget screenShow() {
    return Scaffold(
        backgroundColor: Colors.yellow[300],
        body: Center(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          child: Hero(
                            tag: 'advance_setting_icon',
                            child: Image(
                              gaplessPlayback: true,
                              image: AssetImage("assets/icon_setting.png"),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/advanceSettingScreen');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                    flex: 3,
                    child: GestureDetector(
                      onTapDown: (detail) {
                        TorchCompat.turnOn();
                        setState(() {
                          elevation = 0;

                        });
                      },
                      onTapUp: (detail) {
                        TorchCompat.turnOff();
                        setState(() {
                          elevation = 10;
                          if (isLightOn)
                            buttonImage = buttonImageOff;
                          else
                            buttonImage = buttonImageOn;
                          isLightOn = !isLightOn;
                        });
                      },
                      child: Card(
                        elevation: elevation,
                        color: Colors.yellow[600],
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Image(
                            image: buttonImage,
                            gaplessPlayback: true,
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 30,
                ),
                Flexible(
                  flex: 7,
                  child: ListView(children: <Widget>[
                    Card(
                      color: Colors.yellow[700],
                      elevation: 2,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            flex: 5,
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.only(top: 30, bottom: 30),
                              leading: Hero(
                                tag: 'call_icon',
                                child: Image(
                                  gaplessPlayback: true,
                                  image: AssetImage("assets/icon_call.png"),
                                ),
                              ),
                              title: Hero(
                                tag: 'call_title',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    'Incomming Call',
                                    style: styleTitleMenu,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed('/callScreen');
                              },
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Center(
                                child: Container(
                                    child: DTNSwitch(
                              isTurnOn: incomingCallMode,
                              onChanged: (isChecked) async {
                                if(isChecked){
                                  PermissionStatus status = await Permission.phone.request();
                                  if(status.isPermanentlyDenied){
                                    isOpenDialogSetting = true;
                                    General.showDialogSetting(context);
                                    return false;
                                  }
                                  if(!status.isGranted)
                                    return false;
                                }
                                AndroidPlatform.startService(AndroidPlatform.CALL_ACTION, isChecked);
                                SharePre.sharedPreferences.setBool(
                                    SharePre.INCOMING_CALL_MODE, isChecked);
                                AndroidPlatform.pushDataUserToService(SharePre.INCOMING_CALL_MODE);
                                return true;
                              },
                            ))),
                          )
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.yellow[800],
                      elevation: 2,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            flex: 5,
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.only(top: 30, bottom: 30),
                              leading: Hero(
                                tag: 'notif_icon',
                                child: Image(
                                  image: AssetImage(
                                      "assets/icon_notification.png"),
                                ),
                              ),
                              title: Hero(
                                tag: 'notif_title',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    'Notification',
                                    style: styleTitleMenu,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed('/notifScreen');
                              },
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Center(child: DTNSwitch(
                              isTurnOn: notifMode,
                              onChanged: (isChecked) async {
                                if(isChecked){
                                  PermissionStatus status = await Permission.phone.request();
                                  if(status.isPermanentlyDenied){
                                    isOpenDialogSetting = true;
                                    General.showDialogSetting(context);
                                    return false;
                                  }

                                  if(!status.isGranted)
                                    return false;
                                }

                                SharePre.sharedPreferences.setBool(
                                    SharePre.NOTIF_MODE, isChecked);
                                AndroidPlatform.pushDataUserToService(SharePre.NOTIF_MODE);
                                return true;
                              },
                            )),
                          )
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.yellow[900],
                      elevation: 2,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            flex: 5,
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.only(top: 30, bottom: 30),
                              leading: Hero(
                                tag: 'message_icon',
                                child: Image(
                                  image: AssetImage("assets/icon_sms.png"),
                                ),
                              ),
                              title: Hero(
                                tag: 'message_title',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    'Message',
                                    style: styleTitleMenu,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/messageScreen');
                              },
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Center(child: DTNSwitch(
                              isTurnOn: messageMode,
                              onChanged: (isChecked) async {
                                if(isChecked){
                                  PermissionStatus status = await Permission.sms.request();
                                  if(status.isPermanentlyDenied){
                                    isOpenDialogSetting = true;
                                    General.showDialogSetting(context);
                                    return false;
                                  }
                                  if(!status.isGranted)
                                    return false;
                                }

                                AndroidPlatform.startService(AndroidPlatform.SMS_ACTION, isChecked);
                                SharePre.sharedPreferences.setBool(
                                    SharePre.MESSAGE_MODE, isChecked);
                                AndroidPlatform.pushDataUserToService(SharePre.MESSAGE_MODE);
                                return true;
                              },
                            )),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }

  void initData(){
    incomingCallMode =
        SharePre.sharedPreferences.getBool(SharePre.INCOMING_CALL_MODE);
    messageMode = SharePre.sharedPreferences.getBool(SharePre.MESSAGE_MODE);
    notifMode = SharePre.sharedPreferences.getBool(SharePre.NOTIF_MODE);
  }
}
