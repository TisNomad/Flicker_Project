// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'global_data.dart';
import 'my_painter.dart';
import 'settings_route.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({Key? key}) : super(key: key);

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  void handleDrowDownMenu(String choice) {
    if (choice == "Settings") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Settings()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: handleDrowDownMenu,
            itemBuilder: (BuildContext context) {
              return {"Settings"}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
        centerTitle: true,
        title: const Text("Flicker Project"),
      ),
      body: const MyCanvas(),
    );
  }
}

class MyCanvas extends StatefulWidget {
  const MyCanvas({Key? key}) : super(key: key);

  @override
  State<MyCanvas> createState() => _MyCanvasState();
}

class _MyCanvasState extends State<MyCanvas> {
  bool isAnimating = false;
  var globalFlickerList = [];
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    //print("MyCanvas build method called.");
    final globalFlickerList = context.watch<GlobalData>().flickerList;
    Color backGroundColor =
        Provider.of<GlobalData>(context, listen: false).backGroundColor;
    Color increaseButtonColor = context.watch<GlobalData>().increaseColor;
    Color decreaseButtonColor = context.watch<GlobalData>().decreaseColor;
    Key increaseButtonKey = const Key("inc");
    Key decreaseButtonKey = const Key("dec");

    return Column(
      children: [
        Expanded(
          flex: 10,
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              toggleHzIncrease();
            },
            child: Container(
              color: backGroundColor,
              child: CustomPaint(
                painter: MyPainter.acceptList(globalFlickerList),
                child: Container(),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: backGroundColor,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // INCREASE BUTTON ----------
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                    key: increaseButtonKey,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: increaseButtonColor,
                    ),
                    label: const Text("Increase"),
                    onPressed: () {
                      setState(() {
                        toggleHzIncrease();
                      });
                    },
                  ),
                ),

                // DECREASE BUTTON -------------
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.blue,
                    ),
                    key: decreaseButtonKey,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: decreaseButtonColor,
                    ),
                    label: const Text("Decrease"),
                    onPressed: () {
                      setState(() {
                        toggleHzDecrease();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void toggleHzIncrease() {
    context.read<GlobalData>().toggleHzIncrease();
  }

  void toggleHzDecrease() {
    context.read<GlobalData>().toggleHzDecrease();
  }

  //Toggles animation of the flicker objects
  void toggleAnim() {
    print("toggleAnim() method called.");
    context.read<GlobalData>().toggleFlicker(
        secondaryColor: context.read<GlobalData>().backGroundColor);
  }

  @override
  void initState() {
    super.initState();
    print("initState() called from MyCanvas");
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
  }
}
