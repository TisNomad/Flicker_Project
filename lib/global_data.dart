import 'package:flutter/material.dart';
import 'Flicker.dart';

class GlobalData {
  Color backGroundColor = Colors.black87;
  List<Flicker> flickerList = [];

  void initData() {
    // initialize with 5 items in list.
    for (int i = 0; i < 5; i++) {
      flickerList.add(Flicker.generateRandomFlicker(color: Colors.white));
    }
    print("GlobalData flicker list length: ${flickerList.length}");
  }
}
