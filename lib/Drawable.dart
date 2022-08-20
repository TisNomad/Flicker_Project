import 'dart:ui';

import 'package:flutter/material.dart';

class Drawable {
  void draw() {
    print("draw() Accessed from Drawable interface");
  }

  void drawPaint(Canvas canvas, size) {
    print("drawPaint() Accessed from Drawable interface");
  }
}
