import 'package:flutter/material.dart';
import 'Flicker.dart';

class GlobalData extends ChangeNotifier {
  Color backGroundColor = Colors.black87;
  List<Flicker> flickerList = [];

  GlobalData() {
    print("GlobalData constructor called.");
  }

  void initData() {
    // initialize with 5 items in list.
    print("İnitData() called from ChangeNotifier GlobalData.");
    for (int i = 0; i < 1; i++) {
      flickerList.add(Flicker(Position(200, 250), 30, 5, color: Colors.white));
    }
    print(
        "ChangeNotifier GlobalData flicker list length: ${flickerList.length}");
  }

  void changeColor({required Color secondaryColor}) {
    for (Flicker element in flickerList) {
      element.changeColor(secondaryColor: secondaryColor);
      notifyListeners();
    }
  }
}
