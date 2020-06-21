import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  Function(double) onValueUpdate;

  double minValue;
  double maxValue;
  Color color;

  VoidCallback onUnTouch;

  int tailNumber;

  double currentValue;

  SeekBar(
      {this.onValueUpdate,
      this.maxValue,
      this.minValue,
      this.onUnTouch,
      this.color,
      this.tailNumber,
      this.currentValue}) {
    if (tailNumber == null) tailNumber = 2;
  }

  @override
  _SeekBarState createState() => _SeekBarState(
      onValueUpdate: onValueUpdate,
      minValue: minValue,
      maxValue: maxValue,
      onUnTouch: onUnTouch,
      color: this.color,
      tailNumber: tailNumber,
      currentValue: currentValue);
}

class _SeekBarState extends State<SeekBar> {
  double currentValue;

  double currentDx = null;
  VoidCallback onUnTouch;

  bool isTouching = false;

  Function(double) onValueUpdate;

  Offset startLine = null;
  Offset endLine = null;

  Offset currentOffSet;
  double minValue;
  double maxValue;

  Color color;

  int tailNumber;

  _SeekBarState(
      {this.onValueUpdate,
      this.minValue,
      this.maxValue,
      this.onUnTouch,
      this.color,
      this.tailNumber,
      this.currentValue}) {
    this.currentValue = this.currentValue ?? minValue;
  }

  void calculateSeekBar() {
    if (currentDx != null) {
      if (currentDx > endLine.dx)
        currentDx = endLine.dx;
      else if (currentDx < startLine.dx) currentDx = startLine.dx;
      currentOffSet = Offset(currentDx, startLine.dy);
      currentValue = this.minValue +
          ((currentDx - startLine.dx) / (endLine.dx - startLine.dx)) *
              (this.maxValue - this.minValue);
    } else {
      currentDx = startLine.dx;
      currentValue = this.minValue;
      currentOffSet = startLine;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 18, //80,
        width: 10000,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (detail) {
            setState(() {
              this.currentDx = detail.localPosition.dx;
              calculateSeekBar();
              isTouching = true;
            });
            onValueUpdate(this.currentValue);
          },
          onTapDown: (detail) {
            setState(() {
              this.currentDx = detail.localPosition.dx;
              calculateSeekBar();
              isTouching = true;
            });
            onValueUpdate(this.currentValue);
          },
          onTapUp: (detail) {
            if (onUnTouch != null) onUnTouch();
            setState(() {
              isTouching = false;
            });
          },
          onPanEnd: (detail) {
            if (onUnTouch != null) onUnTouch();
            setState(() {
              isTouching = false;
            });
          },
          onPanCancel: () {
            if (onUnTouch != null) onUnTouch();
            setState(() {
              isTouching = false;
            });
          },
          child: CustomPaint(
            foregroundPainter: new SeekBarPaint(
                backColor: color,
                processColor: color.withAlpha(90),
                isShowValue: true,
                maxValue: this.maxValue,
                minValue: this.minValue,
                isTouching: isTouching,
                currentDx: currentDx,
                currentOffSet: currentOffSet,
                currentValue: currentValue,
                tailNumber: tailNumber,
                onPaintWidget: (startLine, endLine) {
                  if (this.startLine == null) {
                    this.startLine = startLine;
                    this.endLine = endLine;
                  }
                }),
          ),
        ));
  }
}

class SeekBarPaint extends CustomPainter {
  final double strokeWidth = 2;
  final double radiusUnmoveCircle = 8;
  final double radiusMovingCircle = 3;
  final double radiusShadow = 5;
  static final double SPACE_LINEVALUE_VERTICAL_CIRCLE = 2;
  static final double SPACE_LINEVALUE_HORIZONTAL_CIRCLE = 8;
  static final double LENGTH_LINEVALUE_HORIZONTAL = 10;
  Offset endLine = null;
  Offset startLine = null;
  Offset currentOffSet;
  Color backColor;
  Color processColor;
  Paint lineSlide;
  Paint lineValue;
  Paint lineShadow;
  Paint fill;
  Paint lineProcess;
  TextPainter textPainter;
  TextStyle textStyle;

  double maxValue;

  double minValue;
  double currentValue;
  double currentDx;
  bool isTouching;
  double textMaxLength;
  bool isShowValue;
  Function(Offset startLine, Offset endLine) onPaintWidget;

  int tailNumber;

  SeekBarPaint(
      {this.backColor,
      this.maxValue,
      this.minValue,
      this.currentValue,
      this.isTouching,
      this.isShowValue = false,
      this.onPaintWidget,
      this.currentDx,
      this.currentOffSet,
      this.processColor,
      this.tailNumber}) {
    lineSlide = new Paint()
      ..color = backColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    lineValue = new Paint()
      ..color = backColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    lineProcess = new Paint()
      ..color = processColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    lineShadow = new Paint()
      ..color = processColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    fill = new Paint()
      ..color = backColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth;

    textStyle = TextStyle(color: backColor);

    textPainter = TextPainter(
        textAlign: TextAlign.left, textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(
      text: '$maxValue',
      style: textStyle,
    );

    textPainter.layout();
    textMaxLength = textPainter.width;

  }

  void updateState(double currentDx, Size size, bool isTouching) {
    this.isTouching = isTouching;
  }

  @override
  void paint(Canvas canvas, Size size) {
    endLine = Offset(size.width - (radiusUnmoveCircle + textMaxLength),
        size.height - radiusUnmoveCircle - strokeWidth);

    startLine = Offset(0 + radiusUnmoveCircle + strokeWidth,
        size.height - radiusUnmoveCircle - strokeWidth);

    onPaintWidget(startLine, endLine);

    if (currentDx == null) {
      if (currentValue != null) {
        currentDx = startLine.dx + (currentValue - minValue)/(maxValue-minValue)*(endLine.dx - startLine.dx);
        currentOffSet = new Offset(currentDx, startLine.dy);
      } else {
        currentValue = this.minValue;
        currentOffSet = startLine;
        currentDx = startLine.dx;
      }
    }
    canvas.drawLine(startLine, currentOffSet, lineSlide);
    canvas.drawLine(currentOffSet, endLine, lineProcess);

    drawCircle(canvas, size);
    if (isTouching && isShowValue) drawValue(currentDx, canvas, size);
  }

  void drawCircle(Canvas canvas, Size size) {
    if (isTouching)
      drawMovingCircle(canvas, size);
    else
      drawUnMoveCircle(canvas, size);
  }

  void drawUnMoveCircle(Canvas canvas, Size size) {
    canvas.drawCircle(currentOffSet, radiusUnmoveCircle, fill);
  }

  void drawMovingCircle(Canvas canvas, Size size) {
    canvas.drawCircle(currentOffSet, radiusMovingCircle, fill);
    canvas.drawCircle(currentOffSet, radiusShadow, lineShadow);
  }

  void drawValue(double dx, Canvas canvas, Size size) {
    canvas.drawLine(
        Offset(
            dx,
            startLine.dy -
                radiusUnmoveCircle -
                SPACE_LINEVALUE_VERTICAL_CIRCLE),
        Offset(
            dx,
            startLine.dy -
                radiusUnmoveCircle -
                SPACE_LINEVALUE_HORIZONTAL_CIRCLE),
        lineValue);

    canvas.drawLine(
        Offset(
            dx,
            startLine.dy -
                radiusUnmoveCircle -
                SPACE_LINEVALUE_HORIZONTAL_CIRCLE),
        Offset(
            dx + LENGTH_LINEVALUE_HORIZONTAL,
            startLine.dy -
                radiusUnmoveCircle -
                SPACE_LINEVALUE_HORIZONTAL_CIRCLE),
        lineValue);

    textPainter.text = TextSpan(
      text: '${currentValue.toStringAsFixed(tailNumber)}',
      style: textStyle,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(dx, size.height / 2 - 32));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
