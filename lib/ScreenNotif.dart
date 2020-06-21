import 'dart:convert';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ringing_flashlight/CollapseBar.dart';
import 'package:ringing_flashlight/ItemListApp.dart';

import 'AndroidPlarform.dart';
import 'ElasticButton.dart';
import 'SeekBar.dart';
import 'SharePre.dart';

class ScreenNotif extends StatefulWidget {
  @override
  _ScreenNotifState createState() => _ScreenNotifState();
}

class _ScreenNotifState extends State<ScreenNotif>
    with TickerProviderStateMixin {
  static final double minValueSpeed = 0.1;
  static final double maxValueSpeed = 10;

  static final double minValueStrobe = 1;
  static final double maxValueStrobe = 100;
  ScrollPhysics scrollPhysics;

  int tabIndex = 0;
  int countAppChecked = 0;
  int countAppTotal = 0;

  double valueSpeed;

  int valueStrobe;

  List<AppWithCheck> apps = List<AppWithCheck>();
  List<Application> listApps;
  TabController tabController;

  bool isGettingListApp = true;

  @override
  void initState() {
    getList();
    valueSpeed = SharePre.sharedPreferences.getDouble(SharePre.NOTIF_SPEED) ??
        minValueSpeed;
    valueStrobe = SharePre.sharedPreferences.getInt(SharePre.NOTIF_STROBE) ??
        minValueStrobe.round();
    tabController = TabController(vsync: this, length: 2, initialIndex: 0)
      ..addListener(() {
        setState(() {
          tabIndex = tabController.index;
        });
      });
  }

  Future<List<Application>> getList() {
    isGettingListApp = true;
    return DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
        includeAppIcons: true)
      ..then((list) {
        this.listApps = list;
        List<String> packageNamesChecked = SharePre.sharedPreferences
            .getStringList(SharePre.LIST_PACKAGE_NAME_CHECKED);
        setState(() {
          if (packageNamesChecked != null) {
            apps = AppWithCheck.getListWithPackageNamesChecked(
                list, packageNamesChecked);
          } else
            apps = AppWithCheck.getListSameIsCheck(list, true);
          countAppTotal = apps.length;
          isGettingListApp = false;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        List<AppWithCheck> listChecked =
            apps.where((app) => app.isChecked).toList();
        List<String> packageNamesChecked = listChecked
            .map((appWithCheck) => appWithCheck.app.packageName)
            .toList();
        SharePre.sharedPreferences.setStringList(
            SharePre.LIST_PACKAGE_NAME_CHECKED, packageNamesChecked);
        AndroidPlatform.pushDataUserToService(SharePre.LIST_PACKAGE_NAME_CHECKED);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.yellow[800],
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  color: Colors.yellow[800],
                  margin: EdgeInsets.all(0),
                  child: TabBar(
                    controller: tabController,
                    indicatorColor: Colors.yellow[800],
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.yellow[700]),
                    tabs: [
                      Tab(
                        icon: Icon(Icons.settings),
                        text: 'Setup',
                      ),
                      Tab(icon: Icon(Icons.list), text: 'List Application'),
                    ],
                  ),
                ),
              ),
              Flexible(
                  flex: 10,
                  child: TabBarView(
                    physics: this.scrollPhysics,
                    controller: tabController,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: SizedBox.expand(
                              child: Container(
                                color: Colors.yellow[700],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 3,
                                      child: Hero(
                                          tag: 'notif_icon',
                                          child: Image(
                                              image: AssetImage(
                                                  "assets/icon_notification.png"))),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Hero(
                                          tag: 'notif_title',
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Text(
                                              'Notification',
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(
                                        'Number Of Strobe : $valueStrobe times',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Flash light will blink with this number when have a incomming call.',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Container(
                                          width: 300,
                                          child: SeekBar(
                                            currentValue:
                                                this.valueStrobe.toDouble(),
                                            minValue: minValueStrobe,
                                            maxValue: maxValueStrobe,
                                            color: Colors.yellow[700],
                                            onValueUpdate: (currentValue) {
                                              setState(() {
                                                this.valueStrobe =
                                                    currentValue.round();
                                                this.scrollPhysics =
                                                    NeverScrollableScrollPhysics();
                                              });
                                            },
                                            onUnTouch: () {
                                              setState(() {
                                                this.scrollPhysics = null;
                                              });
                                              SharePre.sharedPreferences.setInt(
                                                  SharePre.NOTIF_STROBE,
                                                  this.valueStrobe);

                                              AndroidPlatform
                                                  .pushDataUserToService(
                                                      SharePre.NOTIF_STROBE);
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        'Flash Speed : ${valueSpeed.toStringAsFixed(2)} ms',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Flash light will blink with this speed when have a incomming call.',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Container(
                                          width: 300,
                                          child: SeekBar(
                                            currentValue: this.valueSpeed,
                                            minValue: minValueSpeed,
                                            maxValue: maxValueSpeed,
                                            color: Colors.yellow[700],
                                            onValueUpdate: (currentValue) {
                                              setState(() {
                                                this.valueSpeed = currentValue;
                                                this.scrollPhysics =
                                                    NeverScrollableScrollPhysics();
                                              });
                                            },
                                            onUnTouch: () {
                                              setState(() {
                                                this.scrollPhysics = null;
                                              });
                                              SharePre.sharedPreferences
                                                  .setDouble(
                                                      SharePre.NOTIF_SPEED,
                                                      this.valueSpeed);

                                              AndroidPlatform
                                                  .pushDataUserToService(
                                                      SharePre.NOTIF_SPEED);
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Center(
                                          child: ElasticButton(
                                              color: Colors.yellow[700])),
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: SizedBox.expand(
                              child: Container(
                                color: Colors.yellow[700],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        "$countAppChecked/$countAppTotal",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Hero(
                                          tag: 'notif_title',
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Text(
                                              'Notification',
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Container(
                              color: Colors.white,
                              child: this.isGettingListApp
                                  ? Center(
                                      child: SpinKitRing(
                                        color: Colors.yellow[700],
                                        size: 50.0,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text(
                                              'Application using:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: ListView.separated(
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          Divider(
                                                            color: Colors.grey,
                                                          ),
                                                  itemCount: apps.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ItemListApp(
                                                        apps[index]);
                                                  }),
                                            )
                                          ]),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class AppWithCheck {
  ApplicationWithIcon app;
  bool isChecked;

  AppWithCheck({this.app, this.isChecked});

  static List<AppWithCheck> getListSameIsCheck(
      List<Application> listApp, bool isCheck) {
    List<AppWithCheck> listResult = List<AppWithCheck>();
    for (ApplicationWithIcon item in listApp) {
      listResult.add(AppWithCheck(app: item, isChecked: isCheck));
    }
    return listResult;
  }

  static List<AppWithCheck> getListWithPackageNamesChecked(
      List<Application> listApp, List<String> packageNamesChecked) {
    List<AppWithCheck> listResult = List<AppWithCheck>();
    for (ApplicationWithIcon item in listApp) {
      listResult.add(AppWithCheck(
          app: item,
          isChecked: packageNamesChecked.contains(item.packageName)));
    }
    return listResult;
  }

//  AppWithCheck.fromJson(Map<String, dynamic> json, List<Application> listApps){
//    for(Application app in listApps){
//      if(app.packageName == json['packageName']){
//        this.app = app;
//        this.isChecked = json['isChecked'];
//        return;
//      }
//    }
//    this.app = null;
//    this.isChecked = json['isChecked'];
//  }

//  Map<String, dynamic> toJson() => {
//    'packageName': app.packageName,
//    'isChecked': isChecked
//  };

}
