import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'flicker.dart';
import 'dart:async';

class GlobalData extends ChangeNotifier {
  Color backGroundColor = Colors.black87;
  List<Flicker> flickerList = [];

  GlobalData() {
    initData();
  }

  @Summary("Initializes the data to be used in application.\n"
      "Used once when first program starts.")
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
    if (flickerList.isEmpty) return;
    for (Flicker f in flickerList) {
      if (f.isFlickering) {
        print("Flicker id:${f.id} is already flickering.");
      } else {
        _startFlickerOf(f);
      }
    }
  }

  void _startFlickerOf(Flicker f) {
    f.isFlickering = true;
    if (f.flickerTimer.timer == null) {
      f.flickerTimer.timer =
          Timer.periodic(Duration(milliseconds: 1000 ~/ f.hz), (timer) {
        f.changeColor(secondaryColor: backGroundColor);
        notifyListeners();
      });
    } else {
      print("Flickers are already started.");
    }
  }

  void stopFlicker() {
    if (flickerList.isEmpty) return;
    for (Flicker f in flickerList) {
      _stopFlickerOf(f);
    }
  }

  void _stopFlickerOf(Flicker f) {
    f.isFlickering = false;
    f.flickerTimer.timer?.cancel();
    f.flickerTimer.timer = null;
  }

  void toggleFlicker({required Color secondaryColor}) {
    print("toggleFlicker() method called from global_data");
    if (flickerList.isEmpty) return;
    for (Flicker f in flickerList) {
      if (f.isFlickering) {
        f.draw();
        _stopFlickerOf(f);
      } else {
        _startFlickerOf(f);
      }
    }
  }

  void changeColor({required Color secondaryColor}) {
    for (Flicker element in flickerList) {
      element.changeColor(secondaryColor: secondaryColor);
      notifyListeners();
    }
  }
}
