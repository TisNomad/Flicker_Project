// ignore_for_file: unnecessary_this, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'flicker.dart';
import 'dart:async';

class GlobalData extends ChangeNotifier {
  Color backGroundColor = Colors.black87;
  List<Flicker> flickerList = [];
  List<FlickerTimer> timerList = [];
  bool isIncreasing = false;

  FlickerTimer? findTimer(Flicker f) {
    for (FlickerTimer t in timerList) {
      if (t.id == f.id) return t;
    }
  }

  //When provider is built, initialize data. Called immediately when app starts.
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
    // For each flicker in flickerList,
    // create new FlickerTimer for increasing hz periodicaly
    for (Flicker f in flickerList) {
      timerList.add(FlickerTimer(id: f.id));
    }

    print(
        "ChangeNotifier GlobalData flicker list length: ${flickerList.length}");
    for (Flicker element in flickerList) {
      startFlickerOf(element);
    }
  }

  void toggleHzIncrease() {
    if (isIncreasing) {
      stopIncreasingHz();
    } else {
      startIncreasingHz();
    }
  }

  void startIncreasingHz() {
    isIncreasing = true;
    for (Flicker f in flickerList) {
      increaseFlickerHz(f);
    }
  }

  void stopIncreasingHz() {
    isIncreasing = false;
    for (FlickerTimer t in timerList) {
      t.timer?.cancel();
      t.timer = null;
    }
  }

  //Increase hz periodicaly every given timer period
  void increaseFlickerHz(Flicker f) {
    FlickerTimer t = findTimer(f) as FlickerTimer;
    t.timer?.cancel();
    t.timer = null;
    t.timer = Timer.periodic(Duration(seconds: 2), (timer) {
      f.hz = f.hz + 1;
      setTimerOf(f, f.hz);
    });
  }

  void setTimerOf(Flicker f, int newHz) {
    f.flickerTimer.timer?.cancel();
    f.flickerTimer.timer = null;
    f.flickerTimer.timer =
        Timer.periodic(Duration(milliseconds: 1000 ~/ newHz), (timer) {
      f.changeColor(secondaryColor: backGroundColor);
      notifyListeners();
    });
  }

  void startFlicker({required Color secondaryColor}) {
    if (flickerList.isEmpty) {
      print("flickerList is empty");
      return;
    }
    for (Flicker f in flickerList) {
      if (f.isFlickering) {
        print("Flicker id:${f.id} is already flickering.");
      } else {
        startFlickerOf(f);
      }
    }
  }

  // Used to start flickering of a Flicker object ---------------------
  void startFlickerOf(Flicker f) {
    f.isFlickering = true;

    f.flickerTimer.timer =
        Timer.periodic(Duration(milliseconds: 1000 ~/ f.hz), (timer) {
      f.changeColor(secondaryColor: backGroundColor);
      notifyListeners();
    });

    print("Flicker id:${f.id} started to flicker.");
  }

  //start flicker of a Flicker object with its own method and callback
  @Deprecated("Does not work but the idea should linger for future development")
  void startWithNotify(Flicker f, {required Color secondaryColor}) {
    f.startWithCallback(
      secondaryColor: secondaryColor,
      callback: () {
        notifyListeners();
      },
    );
  }

  void stopFlicker() {
    if (flickerList.isEmpty) return;
    for (Flicker f in flickerList) {
      stopFlickerOf(f);
    }
  }

  // Used to stop flickering of a Flicker object -----------------------
  void stopFlickerOf(Flicker f) {
    f.isFlickering = false;
    f.flickerTimer.timer?.cancel();
    f.flickerTimer.timer = null;

    print("Flicker id:${f.id} stopped flickering.");
  }

  //Toggles between flickering and non-flickering states ---------------
  void toggleFlicker({required Color secondaryColor}) {
    print("toggleFlicker() method called from global_data");
    if (flickerList.isEmpty) return;
    for (Flicker f in flickerList) {
      if (f.isFlickering) {
        stopFlickerOf(f);
      } else {
        startFlickerOf(f);
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
