// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hello_world/Flicker.dart';

List<Flicker> flickerList = [];

void initData() {
  print("initData() called from global");
  if (flickerList.isEmpty) {
    for (int i = 0; i < 1; i++) {
      flickerList.add(Flicker(Position(150, 250), 30, 5, color: Colors.white));
    }
  } else {
    print("FlickerList already has data/ initData() already called before");
  }
}
