import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';

import 'AndroidPlarform.dart';
import 'ElasticButton.dart';
import 'SeekBar.dart';
import 'SharePre.dart';

class ScreenAdvanceSetting extends StatefulWidget {
  @override
  _ScreenAdvanceSettingState createState() => _ScreenAdvanceSettingState();
}

class _ScreenAdvanceSettingState extends State<ScreenAdvanceSetting> {
  static final double minValuePercent = 1;
  static final double maxValueSpeed = 100;
  double valuePercent = minValuePercent;
  bool isEnableBatteryMode;
  bool isEnableTimeMode;

  double xSeekBar;

  bool isTouching = false;

  double currentDx;
  double currentValue;

  double widthSeekBar = 300;

  Size size;

  final double strokeWidth = 2;
  final double radiusUnmoveCircle = 8;
  final double radiusMovingCircle = 3;
  final double radiusShadow = 5;

  DateTime timeFrom ;
  DateTime timeTo ;


  double getCurrentValue() {
    Offset endLine = Offset(size.width - (radiusUnmoveCircle + 70),
        size.height - radiusUnmoveCircle - strokeWidth);

    Offset startLine = Offset(0 + radiusUnmoveCircle + strokeWidth,
        size.height - radiusUnmoveCircle - strokeWidth);
    if (currentDx != null) {
      if (currentDx > endLine.dx)
        currentDx = endLine.dx;
      else if (currentDx < startLine.dx) currentDx = startLine.dx;

      return ((currentDx - startLine.dx) / (endLine.dx - startLine.dx)) * 100;
    } else {
      return 0;
    }
  }


  @override
  void initState() {

    valuePercent = SharePre.sharedPreferences.getDouble(SharePre.SETTING_PERCENT) ??minValuePercent;

    timeFrom = DateTime.parse(SharePre.sharedPreferences.getString(SharePre.SETTING_TIME_FROM)?? '2020-01-01 12:00:00.000');

    timeTo = DateTime.parse(SharePre.sharedPreferences.getString(SharePre.SETTING_TIME_TO)?? '2020-01-01 24:00:00.000');

    isEnableBatteryMode = SharePre.sharedPreferences.getBool(SharePre.SETTING_BATTERY_MODE)?? false;

    isEnableTimeMode = SharePre.sharedPreferences.getBool(SharePre.SETTING_TIME_MODE)?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: SizedBox.expand(
              child: Container(
                color: Colors.yellow[300],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Flexible(
                      flex: 3,
                      child: Hero(
                          tag: 'advance_setting_icon',
                          child: Image(
                            image: AssetImage("assets/icon_setting.png"),
                          )),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        'Advance Setting',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'ON/OFF BATTERY MODE',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(),
                          ),
                          Switch(
                            activeColor: Colors.yellow[300],
                            value: this.isEnableBatteryMode,
                            onChanged: (value) {
                              SharePre.sharedPreferences.setBool(
                                  SharePre.SETTING_BATTERY_MODE, value);

                              AndroidPlatform.pushDataUserToService(SharePre.SETTING_BATTERY_MODE);
                            },
                          )
                        ],
                      ),
                      Text(
                        'Disable level : ${valuePercent.toStringAsFixed(0)} %',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Disable all feature of Ringing FlashLight when battery level is lower than disable level.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Container(
                          width: 300,
                          child: SeekBar(
                            minValue: minValuePercent,
                            maxValue: maxValueSpeed,
                            currentValue: valuePercent,
                            tailNumber: 0,
                            color: Colors.yellow[300],
                            onUnTouch: (){
                              SharePre.sharedPreferences.setDouble(
                                  SharePre.SETTING_PERCENT, this.valuePercent);
                              AndroidPlatform.pushDataUserToService(SharePre.SETTING_PERCENT);
                            },
                            onValueUpdate: (currentValue) {
                              setState(() {
                                this.valuePercent = currentValue;
                              });
                            },
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'ON/OFF TIME MODE',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(),
                          ),
                          Switch(
                            activeColor: Colors.yellow[300],
                            value: this.isEnableTimeMode,
                            onChanged: (value) {
                              SharePre.sharedPreferences.setBool(
                                  SharePre.SETTING_TIME_MODE, value);

                              AndroidPlatform.pushDataUserToService(SharePre.SETTING_TIME_MODE);
                            },
                          ),
                        ],
                      ),
                      Text(
                        'Disable distance :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Disable all feature of Ringing FlashLight when current time in this distance.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(

                        children: <Widget>[
                          Text('From'),
                          SizedBox(width: 20,),
                          GestureDetector(
                            onTap: () async {
                              await showDialog(context: context,builder: (context){
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0.0,
                                  backgroundColor: Colors.white,
                                  child: TimePickerSpinner(
                                    time: timeFrom,
                                    is24HourMode: false,
                                    normalTextStyle: TextStyle(
                                        fontSize: 24,
                                        color: Colors.grey
                                    ),
                                    highlightedTextStyle: TextStyle(
                                        fontSize: 30,
                                        color: Colors.grey[800]
                                    ),
                                    spacing: 50,
                                    itemHeight: 80,
                                    isForce2Digits: true,
                                    onTimeChange: (time) {
                                      setState(() {
                                        timeFrom = time;
                                      });
                                    },
                                  ),
                                );
                              });
                              SharePre.sharedPreferences.setString(
                                  SharePre.SETTING_TIME_FROM, this.timeFrom.toString());
                              AndroidPlatform.pushDataUserToService(SharePre.SETTING_TIME_FROM);
                            },
                            child: Text(
                              new DateFormat('HH:mm').format(timeFrom),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Text('To'),
                          SizedBox(width: 20,),
                          GestureDetector(
                            onTap: () async {
                               await showDialog(context: context,builder: (context){
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0.0,
                                  backgroundColor: Colors.white,
                                  child: TimePickerSpinner(
                                    time: timeTo,
                                    is24HourMode: false,
                                    normalTextStyle: TextStyle(
                                        fontSize: 24,
                                        color: Colors.grey
                                    ),
                                    highlightedTextStyle: TextStyle(
                                        fontSize: 30,
                                        color: Colors.grey[800]
                                    ),
                                    spacing: 50,
                                    itemHeight: 80,
                                    isForce2Digits: true,
                                    onTimeChange: (time) {
                                      setState(() {
                                        timeTo = time;
                                      });
                                    },
                                  ),
                                );
                              });
                               SharePre.sharedPreferences.setString(
                                   SharePre.SETTING_TIME_TO, this.timeTo.toString());
                               AndroidPlatform.pushDataUserToService(SharePre.SETTING_TIME_TO);
                            },
                            child: Text(
                              new DateFormat('HH:mm').format(timeTo),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ]),
              ))
        ],
      ),
    );
  }
}
