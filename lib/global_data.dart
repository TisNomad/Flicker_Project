import 'package:flutter/material.dart';
import 'flicker.dart';
import 'dart:async';

class GlobalData extends ChangeNotifier {
  Color backGroundColor = Colors.black87;
  List<Flicker> flickerList = [];

  GlobalData() {
    initData();
  }

  void initData() {
    // initialize with 5 items in list.
    print("İnitData() called from ChangeNotifier GlobalData.");
    for (int i = 0; i < 1; i++) {
      flickerList.add(Flicker(Position(200, 250), 30, 5, color: Colors.white));
      print(flickerList.length);
    }
    print(
        "ChangeNotifier GlobalData flicker list length: ${flickerList.length}");
    for (Flicker element in flickerList) {
      element.startFlicker(secondaryColor: backGroundColor);
    }
  }

  void startFlicker({required Color secondaryColor}) {
    for (Flicker element in flickerList) {
      var f = element;
      f.isFlickering = true;
      f.flickerTimer.timer?.cancel();
      f.flickerTimer.timer = null;
      f.flickerTimer.timer =
          Timer.periodic(Duration(milliseconds: 1000 ~/ f.hz), (timer) {
        f.changeColor(secondaryColor: secondaryColor);
        notifyListeners();
      });
    }
  }

  void stopFlicker() {
    for (Flicker element in flickerList) {
      var f = element;
      f.isFlickering = false;
      f.flickerTimer.timer?.cancel();
      f.flickerTimer.timer = null;
    }
  }

  void changeColor({required Color secondaryColor}) {
    for (Flicker element in flickerList) {
      element.changeColor(secondaryColor: secondaryColor);
      notifyListeners();
    }
  }
}
