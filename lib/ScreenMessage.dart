import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AndroidPlarform.dart';
import 'ElasticButton.dart';
import 'SeekBar.dart';
import 'SharePre.dart';

class ScreenMessage extends StatefulWidget {
  @override
  _ScreenMessageState createState() => _ScreenMessageState();
}

class _ScreenMessageState extends State<ScreenMessage> {
  static final double minValueSpeed = 0.1;
  static final double maxValueSpeed = 10;

  static final double minValueStrobe = 1;
  static final double maxValueStrobe = 100;

  double valueSpeed = minValueSpeed;
  int valueStrobe = minValueStrobe.round();

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
    valueSpeed = SharePre.sharedPreferences.getDouble(SharePre.MESSAGE_SPEED) ?? minValueSpeed;

    valueStrobe = SharePre.sharedPreferences.getInt(SharePre.MESSAGE_STROBE) ??
        minValueStrobe.round();
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
                color: Colors.yellow[900],
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
                          tag: 'message_icon',
                          child: Image(
                            image: AssetImage("assets/icon_sms.png"),
                          )),
                    ),
                    Flexible(
                      flex: 2,
                      child: Hero(
                          tag: 'message_title',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              'Message',
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
                        'Number Of Strobe : $valueStrobe times',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Flash light will blink with this number when have a incomming call.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          width: 300,
                          child: SeekBar(
                            minValue: minValueStrobe,
                            maxValue: maxValueStrobe,
                            currentValue: this.valueStrobe.toDouble(),
                            color: Colors.yellow[900],
                            onUnTouch: () {
                              SharePre.sharedPreferences.setInt(
                                  SharePre.MESSAGE_STROBE,
                                  this.valueStrobe);
                              AndroidPlatform.pushDataUserToService(SharePre.MESSAGE_STROBE);
                            },
                            onValueUpdate: (currentValue) {
                              setState(() {
                                this.valueStrobe = currentValue.round();
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Flash Speed : ${valueSpeed.toStringAsFixed(2)} ms',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Flash light will blink with this speed when have a incomming call.',
                        style: TextStyle(fontStyle: FontStyle.italic),
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
                            color: Colors.yellow[900],
                            onUnTouch: () {
                              SharePre.sharedPreferences.setDouble(
                                  SharePre.MESSAGE_SPEED, this.valueSpeed);
                              AndroidPlatform.pushDataUserToService(SharePre.MESSAGE_SPEED);
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
                      Center(child: ElasticButton(color: Colors.yellow[900])),
                    ]),
              ))
        ],
      ),
    );
  }
}
