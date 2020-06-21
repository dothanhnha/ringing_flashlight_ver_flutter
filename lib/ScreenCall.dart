import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ringing_flashlight/SharePre.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AndroidPlarform.dart';
import 'ElasticButton.dart';
import 'SeekBar.dart';

class ScreenCall extends StatefulWidget {
  @override
  _ScreenCallState createState() => _ScreenCallState();
}

class _ScreenCallState extends State<ScreenCall> {
  static final double minValueSpeed = 0.1;
  static final double maxValueSpeed = 10;
  double valueSpeed ;

  final double strokeWidth = 2;
  final double radiusUnmoveCircle = 8;
  final double radiusMovingCircle = 3;
  final double radiusShadow = 5;

  @override
  void initState() {
    valueSpeed = SharePre.sharedPreferences.getDouble(SharePre.CALL_SPEED) ?? minValueSpeed;
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
                color: Colors.yellow[700],
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
                          tag: 'call_icon',
                          child: Image(
                            image: AssetImage("assets/icon_call.png"),
                          )),
                    ),
                    Flexible(
                      flex: 2,
                      child: Hero(
                          tag: 'call_title',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              'Incomming Call',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
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
                      Text(
                        'Flash Speed : ${valueSpeed.toStringAsFixed(2)} ms',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Flash light will blink with this speed when have a incomming call.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Container(
                          width: 300,
                          child: SeekBar(
                            minValue: minValueSpeed,
                            maxValue: maxValueSpeed,
                            currentValue: valueSpeed,
                            color: Colors.yellow[700],
                            onUnTouch: (){
                              SharePre.sharedPreferences.setDouble(
                                  SharePre.CALL_SPEED, this.valueSpeed);
                              AndroidPlatform.pushDataUserToService(SharePre.CALL_SPEED);
                            },
                            onValueUpdate: (currentValue) {
                              setState(() {
                                this.valueSpeed = currentValue;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: ElasticButton(color: Colors.yellow[700]),
                      )
                    ]),
              ))
        ],
      ),
    );
  }
}
