// ignore_for_file: unnecessary_this, avoid_print, prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'flicker.dart';
import 'dart:async';
import 'my_math.dart' as my_math;

//Main provider of data for the app
class GlobalData extends ChangeNotifier {
  Color backGroundColor = Colors.black87;
  Color increaseColor = Colors.black87;
  Color decreaseColor = Colors.black87;
  List<Flicker> flickerList = [];
  List<FlickerTimer> _timerList = [];
  bool _isIncreasing = false;
  bool _isDecreasing = false;
  int _differenceValue = 1;
  int _differenceSpeed = 1;
  int _defaultHz = 10;
  List<String> pageList = ["Settings"];
  var settingsValueList = <dynamic>[];

  void _changeIncButtonColor() {
    if (_isIncreasing) {
      increaseColor = Colors.grey[800] as Color;
    } else {
      increaseColor = Colors.black87;
    }
    notifyListeners();
  }

  void _changeDecButtonColor() {
    if (_isDecreasing) {
      decreaseColor = Colors.grey[800] as Color;
    } else {
      decreaseColor = Colors.black87;
    }
    notifyListeners();
  }

  FlickerTimer? _findTimer(Flicker f) {
    for (FlickerTimer t in _timerList) {
      if (t.id == f.id) return t;
    }
    return null;
  }

  //When provider is built, initialize data. Called immediately when app starts.
  GlobalData() {
    _initData();
  }

  @Summary("Initializes the data to be used in application.\n"
      "Used once when first program starts.")
  void _initData() {
    // initialize with 5 items in list.
    print("İnitData() called from ChangeNotifier GlobalData.");
    for (int i = 0; i < 1; i++) {
      flickerList.add(
          Flicker(Position(200, 250), 30, _defaultHz, color: Colors.white));
      print(flickerList.length);
    }
    // For each flicker in flickerList,
    // create new FlickerTimer for increasing hz periodicaly
    for (Flicker f in flickerList) {
      _timerList.add(FlickerTimer(id: f.id));
    }

    print(
        "ChangeNotifier GlobalData flicker list length: ${flickerList.length}");
    for (Flicker element in flickerList) {
      _startFlickerOf(element);
    }

    settingsValueList.addAll(<dynamic>[true, false]);
  }

  void refreshHz() {
    _stopChangingHz();
    for (Flicker f in flickerList) {
      _setTimerOf(f, _defaultHz);
      f.hz = _defaultHz;
    }
    notifyListeners();
  }

  void toggleHzIncrease() {
    if (_isIncreasing) {
      _stopChangingHz();
    } else {
      startIncreasingHz();
    }
  }

  void toggleHzDecrease() {
    if (_isDecreasing) {
      _stopChangingHz();
    } else {
      for (Flicker f in flickerList) {
        if (f.hz < 2) return;
      }
      startDecreasingHz();
    }
  }

  void startDecreasingHz() {
    _differenceValue = my_math.abs(_differenceValue) as int;
    _differenceValue *= -1;
    //Made the change value negative
    _isIncreasing = false;
    _isDecreasing = true;
    _changeDecButtonColor();
    _changeIncButtonColor();
    for (Flicker f in flickerList) {
      _changeFlickerHz(f);
    }
  }

  void startIncreasingHz() {
    _differenceValue = my_math.abs(_differenceValue) as int;
    //Made the change value positive
    _isIncreasing = true;
    _isDecreasing = false;
    _changeDecButtonColor();
    _changeIncButtonColor();
    for (Flicker f in flickerList) {
      _changeFlickerHz(f);
    }
  }

  void _stopChangingHz() {
    _isIncreasing = false;
    _isDecreasing = false;
    for (FlickerTimer t in _timerList) {
      t.timer?.cancel();
      t.timer = null;
    }
    _changeDecButtonColor();
    _changeIncButtonColor();
  }

  //Increase hz periodicaly every given timer period
  void _changeFlickerHz(Flicker f) {
    FlickerTimer t = _findTimer(f) as FlickerTimer;
    t.timer?.cancel();
    t.timer = null;
    t.timer = Timer.periodic(Duration(seconds: _differenceSpeed), (timer) {
      f.hz = f.hz + _differenceValue;
      _setTimerOf(f, f.hz);
      if (f.hz < 2) {
        t.timer!.cancel();
        t.timer = null;
      }
    });
  }

  //Set the periodic timer for Flicker f. Meant to be used internally
  void _setTimerOf(Flicker f, int newHz) {
    f.flickerTimer.timer?.cancel();
    f.flickerTimer.timer = null;
    f.flickerTimer.timer =
        Timer.periodic(Duration(milliseconds: 1000 ~/ newHz), (timer) {
      f.changeColor(secondaryColor: backGroundColor);
      notifyListeners();
    });
  }

  // ignore: unused_element
  void _startFlicker({required Color secondaryColor}) {
    if (flickerList.isEmpty) {
      print("flickerList is empty");
      return;
    }
    for (Flicker f in flickerList) {
      if (f.isFlickering) {
        print("Flicker id:${f.id} is already flickering.");
      } else {
        _startFlickerOf(f);
      }
    }
  }

  // Used to start flickering of a Flicker object ---------------------
  void _startFlickerOf(Flicker f) {
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
  // ignore: unused_element
  void _startWithNotify(Flicker f, {required Color secondaryColor}) {
    f.startWithCallback(
      secondaryColor: secondaryColor,
      callback: () {
        notifyListeners();
      },
    );
  }

  // ignore: unused_element
  void _stopFlicker() {
    if (flickerList.isEmpty) return;
    for (Flicker f in flickerList) {
      _stopFlickerOf(f);
    }
  }

  // Used to stop flickering of a Flicker object -----------------------
  void _stopFlickerOf(Flicker f) {
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
        _stopFlickerOf(f);
      } else {
        _startFlickerOf(f);
      }
    }
  }

  // ignore: unused_element
  void _changeColor({required Color secondaryColor}) {
    for (Flicker element in flickerList) {
      element.changeColor(secondaryColor: secondaryColor);
      notifyListeners();
    }
  }
}
