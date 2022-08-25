//Custom Painter class for rendering on the canvas
import 'package:flutter/material.dart';

import 'drawable.dart';

class MyPainter extends CustomPainter {
  //List<Flicker> flickerList = [];
  var list = [];

  MyPainter.acceptList(this.list);

  @override
  void paint(Canvas canvas, Size size) {
    //Generic paint operation for any object that is Drawable
    if (list.isEmpty) return;

    for (int i = 0; i < list.length; i++) {
      if (list[i] is Drawable) {
        list[i].drawPaint(canvas, size);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
