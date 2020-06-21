import 'package:flutter/material.dart';

class CollapseBar extends StatefulWidget {
  @override
  _CollapseBarState createState() => _CollapseBarState();
}

double height;

class _CollapseBarState extends State<CollapseBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        ///height: this.height,
        color: Colors.purple[300],
        child: Padding(
          padding: EdgeInsets.only(top: 40, bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Hero(
                    tag: 'notif_icon',
                    child: Image(
                      image:
                      AssetImage("assets/icon_notification.png"),
                    )),
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
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
