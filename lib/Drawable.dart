// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';

abstract class Drawable {
  void draw();

  void drawPaint(Canvas canvas, size);
}
