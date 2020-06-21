import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DTNSwitch extends StatefulWidget {
  void Function(bool value) onChanged;

  bool isTurnOn;

  DTNSwitch({this.onChanged, this.isTurnOn});

  @override
  _DTNSwitchState createState() =>
      _DTNSwitchState(isTurnOn: isTurnOn, onChanged: onChanged);
}

class _DTNSwitchState extends State<DTNSwitch> with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  Future<bool> Function(bool value) onChanged;
  double width = 30;
  double height = 60;

  _DTNSwitchState({this.isTurnOn, this.onChanged}) {
    if (this.isTurnOn == null) this.isTurnOn = false;

    if (!isTurnOn)
      dySwitch = height / 4;
    else
      dySwitch = 3 * height / 4;
  }

  bool isTurnOn;
  double dySwitch;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        bool valid = true;
        if (onChanged != null) {
          valid =  await onChanged(!isTurnOn);
        }
        if(!valid)
          return;

        isTurnOn = !isTurnOn;
        controller = AnimationController(
            vsync: this, duration: Duration(milliseconds: 100));
        controller.addListener(() {
          setState(() {
            this.dySwitch = animation.value;
          });
        });
        animation = Tween<double>(
                begin: this.dySwitch,
                end: isTurnOn ? 3 * height / 4 : height / 4)
            .animate(controller);
        controller.forward();
      },
      child: Container(
          width: width,
          height: height,
          child: CustomPaint(
            foregroundPainter:
                new SwitchPaint(isTurnOn: isTurnOn, dySwitch: dySwitch),
          )),
    );
  }
}

class SwitchPaint extends CustomPainter {
  double dySwitch = null;
  final double paddingLineSwitch_A = 6;
  final double paddingLineSwitch_B = 4;

  bool isTurnOn;

  SwitchPaint({this.isTurnOn, this.dySwitch});

  Paint lineRect = new Paint()
    ..color = Colors.grey[400]
    ..strokeCap = StrokeCap.square
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  Paint lineSwitch = new Paint()
    ..color = Colors.white
    ..strokeCap = StrokeCap.square
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  Paint fillRect = new Paint()
    ..color = Colors.grey[400]
    ..strokeCap = StrokeCap.square
    ..style = PaintingStyle.fill
    ..strokeWidth = 3;

  Paint fillBack = new Paint()
    ..color = Colors.grey[400]
    ..strokeCap = StrokeCap.square
    ..style = PaintingStyle.fill
    ..strokeWidth = 3;

  Paint fillOn = new Paint()
    ..color = Colors.green
    ..strokeCap = StrokeCap.square
    ..style = PaintingStyle.fill
    ..strokeWidth = 3;

  Paint fillOff = new Paint()
    ..color = Colors.red
    ..strokeCap = StrokeCap.square
    ..style = PaintingStyle.fill
    ..strokeWidth = 3;

  TextStyle textStyle = TextStyle(color: Colors.white);

  TextPainter textPainter =
      TextPainter(textAlign: TextAlign.left, textDirection: TextDirection.ltr);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(size.width / 2, size.height / 2),
                width: size.width,
                height: size.height),
            Radius.circular(0)),
        fillBack);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(size.width / 2, size.height / 4),
                width: size.width,
                height: size.height / 2),
            Radius.circular(0)),
        fillOn);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(size.width / 2, 3 * size.height / 4),
                width: size.width,
                height: size.height / 2),
            Radius.circular(0)),
        fillOff);

    textPainter.text = TextSpan(
      text: 'ON',
      style: textStyle,
    );

    textPainter.layout();

    textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2,
            (size.height / 2 - textPainter.height) / 2));

    textPainter.text = TextSpan(
      text: 'OFF',
      style: textStyle,
    );

    textPainter.layout();

    textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2,
            (size.height / 2) + (size.height / 2 - textPainter.height) / 2));

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(size.width / 2, dySwitch),
                width: size.width,
                height: size.height / 2),
            Radius.circular(0)),
        fillRect);

    canvas.drawLine(
        Offset(paddingLineSwitch_A, dySwitch - size.height / 8),
        Offset(size.width - paddingLineSwitch_A, dySwitch - size.height / 8),
        lineSwitch);

    canvas.drawLine(Offset(paddingLineSwitch_B, dySwitch),
        Offset(size.width - paddingLineSwitch_B, dySwitch), lineSwitch);

    canvas.drawLine(
        Offset(paddingLineSwitch_A, dySwitch + size.height / 8),
        Offset(size.width - paddingLineSwitch_A, dySwitch + size.height / 8),
        lineSwitch);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
