import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ElasticButton extends StatefulWidget {
  Color color;


  ElasticButton({this.color});

  @override
  _ElasticButtonState createState() => _ElasticButtonState(color: color);
}

class _ElasticButtonState extends State<ElasticButton>
    with TickerProviderStateMixin {
  AnimationController _controller1;
  AnimationController _controller2;
  Animation _animation;
  double ratio = 1;
  double ratioWhenPanEnd;
  Color color;


  _ElasticButtonState({this.color});

  @override
  void initState() {
    _controller1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _controller1.addListener(() {
      setState(() {
        print('tap down ${_animation.value}');
        ratio = _animation.value;
        if(this.ratio < 0.85 ){
          _controller2.reset();
          _animation = Tween<double>(begin: ratio, end: 1).animate(
              CurvedAnimation(
                  parent: _controller2, curve: Curves.elasticOut));
          _controller2.forward();
        }
      });
    });
    _controller2 = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _controller2.addListener(() {
      setState(() {
        ratio = _animation.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 53,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (detail){
            _controller1.reset();
            _animation =
                Tween<double>(begin: ratio, end: 0.7).animate(_controller1);
            _controller1.forward();
          },
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: 200,
                  height: 50,
                  color: Colors.transparent,
                  child: CustomPaint(
                    foregroundPainter: new ElasticButtonPaint(ratio: ratio,color: color),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'TEST FLASHLIGHT',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15 * ratio,
                  color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }
}

class ElasticButtonPaint extends CustomPainter {
  double ratio;
  final double radius = 40;

  Color color;
  Paint lineRect;
  Paint fillRect;

  ElasticButtonPaint({this.ratio,this.color}){
    lineRect = new Paint()
      ..color = this.color
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    fillRect = new Paint()
      ..color = this.color.withAlpha(this.color.alpha +300)
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;
  }



  TextStyle textStyle = TextStyle(color: Colors.red);

  TextPainter textPainter =
      TextPainter(textAlign: TextAlign.left, textDirection: TextDirection.ltr);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: 200 * ratio,
            height: 50 * ratio),
        fillRect);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: 200 * ratio,
            height: 50 * ratio),
        lineRect);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
