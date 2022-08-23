// ignore_for_file: unnecessary_this

import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

import 'drawable.dart';

class FlickerTimer {
  late Timer? timer;
  late int id;

  FlickerTimer({this.id = -1}) {
    timer = null;
  }

  bool checkTimerId(int id) {
    if (this.id == id) {
      return true;
    } else {
      return false;
    }
  }
}

class Position {
  late double x;
  late double y;

  Position(this.x, this.y);
}

class Flicker implements Drawable {
  static int idGen = 1;

  int id = -1;
  late Position pos;
  late int size;
  late int hz;
  late Color colorTemp;
  late Color color = Colors.black;
  late Color secondaryColor;
  late FlickerTimer flickerTimer;
  bool isFlickering = false;

  Flicker(this.pos, this.size, this.hz, {this.color = Colors.black}) {
    this.id = Flicker.idGen;
    Flicker.idGen++;
    this.colorTemp = color;
    flickerTimer = FlickerTimer(id: this.id);
  }

  static Flicker generateRandomFlicker({required Color color}) {
    Position c =
        Position(Random().nextInt(250) + 50, Random().nextInt(600) + 100);
    int radius = 30;
    int herz = Random().nextInt(51) + 5;
    return Flicker(c, radius, herz, color: Colors.white);
  }

  static Flicker randomPosChange(Flicker f) {
    f.pos.x += 1 * (Random().nextInt(3) - 1);
    f.pos.y += 1 * (Random().nextInt(3) - 1);
    return f;
  }

  @override
  @Deprecated("Use drawPaint() instead for use in CustomPainter"
      " with details of canvas context, size and position")
  void draw() {}

  void changeColor({required Color secondaryColor}) {
    if (this.isFlickering) {
      if (color == colorTemp) {
        color = secondaryColor;
      } else {
        color = colorTemp;
      }
    }
  }

  void startFlicker({required Color secondaryColor}) {
    if (isFlickering == false) {
      this.isFlickering = true;
      this.secondaryColor = secondaryColor;
      this.flickerTimer.timer =
          Timer.periodic(Duration(milliseconds: 1000 ~/ this.hz), (timer) {
        changeColor(secondaryColor: secondaryColor);
      });
    }
  }

  void stopFlicker() {
    if (isFlickering) {
      this.isFlickering = false;
      this.flickerTimer.timer?.cancel();
      this.flickerTimer.timer = null;
    }
  }

  void toggleFlicker({required Color secondaryColor}) {
    if (this.isFlickering) {
      stopFlicker();
    } else {
      startFlicker(secondaryColor: secondaryColor);
    }
  }

  @override
  void drawPaint(Canvas canvas, size) {
    Size cSize = size as Size;
    var c = Offset(this.pos.x, this.pos.y);
    var paint = Paint()
      ..color = this.color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(c, this.size.toDouble(), paint);

    TextSpan span =
        TextSpan(text: "${this.hz}", style: TextStyle(color: Colors.blue));
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, c);
  }

  get instance => this;
}
